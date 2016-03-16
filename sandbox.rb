#!/usr/bin/env ruby

require "gosu"
require "yaml"

require_relative "player"
require_relative "enemy"
require_relative "enemyformation"
require_relative "enemyspixon"
require_relative "enemycannon"
require_relative "enemymobile"
require_relative "enemycircular"
require_relative "enemyarc"
require_relative "asteroid"
require_relative "bullet"
require_relative "bonusitem"
require_relative "explosion"
require_relative "scoreboard"
require_relative "highscorelist"
require_relative "credit"
require_relative "scenemanager"
require_relative "gamecontext"

class Sandbox < Gosu::Window 

	WIDTH = 800
	HEIGHT = 600
	CENTER = (WIDTH / 2)	

	def initialize()

		@enemies = []
		@bullets = []
		@explosions = []

		@config = YAML.load_file("config.yml")

		super(WIDTH, HEIGHT, fullscreen = @config["fullscreen"])

		@appeared = 1

		@sounds = []

		@window_attributes = {}
		@window_attributes["width"] = WIDTH
		@window_attributes["height"] = HEIGHT
		@window_attributes["center"] = CENTER

		@player = Player.new(@name, @config, @window_attributes)
		@gamecontext = GameContext.new(@player, @window_attributes, @config, @sounds, @scoreboard, @colors)

		@max_threshold = @gamecontext.config["levelone"]["max_num_ships_that_can_escape"]
		@enemy_frequency = @gamecontext.config["levelone"]["enemy_frequency"]
		@bonus_item_frequency = @gamecontext.config["levelone"]["bonus_item_frequency"]
		@slow_speed = @gamecontext.config["levelone"]["enemy_slow_speed"]
		@fast_speed = @gamecontext.config["levelone"]["enemy_slow_speed"]
		@speed_ratio = @gamecontext.config["levelone"]["speed_ratio"]
		@bg_static = Gosu::Image.new("images/bg_image.png")		
		@spawned = false

		# Pattern
		# TODO: Move the formation, one by one		
		# ef = EnemyFormation.new(@gamecontext, [6,4])
		# puts ef.enemies.size
		# ef.enemies.each do |e|
		# 	@enemies << e
		# end
		# puts "Added #{ef.enemies.size} to #{@enemies.size}"
		# @enemies.each do |e|
		# 	puts "Created: #{e.name}"
		# end

		# Pattern
		# TODO: Move this to a EnemyDestroyer.rb class
		# 5.times do
		#  	x = rand(0...@config["width"])
		#  	y = rand(0...@config["height"])
		# 	@enemies << EnemyCannon.new(@gamecontext, 2, x, y)
		#  	#@enemies << EnemyCannon.new(@gamecontext, 2, 500, 500)
		# end

		# Pattern
		# TODO: Move the movement out into an algorithm
		# TODO: Find a way to move the enemy between a list of coordinates
		@enemies << EnemyArc.new(@gamecontext, 2, 150, 50, [150, 400])

		# Pattern:
		# Moves in a downwards then orbits then returns
		#@enemies << EnemyCircular.new(@gamecontext, 3, 400, 50)
	end

	def draw

		@bg_static.draw(0, 0, 0)

		@player.draw

		@enemies.each do |e|
			e.draw
		end

		@bullets.each do |b|
			b.draw
		end

		@explosions.each do |e|
			e.draw
		end

		collision_detection()		
	end

	def update()

		@player.turn_left if button_down?(Gosu::KbLeft) 
		@player.turn_right if button_down?(Gosu::KbRight) 
		@player.accelerate if button_down?(Gosu::KbUp)
		@player.backwards if button_down?(Gosu::KbDown)

		@player.move()

		if !@spawned
			@spawned = true
		end

		@enemies.each do |e|
			e.move
			if e.escaped?
				e.respawn()
			end
		end

		@bullets.each do |b|
			b.move
		end

		return collision_detection()
	end

	def button_down(id)

		if id == Gosu::KbSpace
			@bullets << Bullet.new(@gamecontext, @player.x, @player.y, @player.angle)
		end
	end

	def collision_detection

		@enemies.dup().each do |e|

			@bullets.each do |b|

				distance = Gosu.distance(e.x, e.y, b.x, b.y)

				if distance < e.radius + b.radius
					@enemies.delete	e
					@bullets.delete b
					@explosions << Explosion.new(@gamecontext, e.x, e.y)
					@destroyed += 1

					@gamecontext.scoreboard.points += 10
				end
			end
		end

		@explosions.dup().each do |e|
			@explosions.delete e if e.finished
		end

		@enemies.dup().each do |e|
			if e.y > @gamecontext.window_attributes["height"] + e.radius
				@enemies.delete e
			end
		end

		@bullets.dup().each do |b|

			if !b.on_screen?
				@bullets.delete b
			end
		end
		
		# Collision detection for player
		@enemies.each do |e|
			
			distance = Gosu::distance(e.x, e.y, @player.x, @player.y)
			if distance < @player.radius + e.radius
				return :level_failed, "You were hit by an enemy ship"
			end
		end

		if @player.y < -@player.radius
			return :level_failed, "You left your base and were destroyed!"
		end

		return :no_action_to_take
	end
end

sandbox = Sandbox.new()
sandbox.show()