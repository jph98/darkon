#!/usr/bin/env ruby

class LevelTwo

	attr_accessor :name

	def initialize(gamecontext)

		@asteroids = []
		@bullets = []
		@explosions = []
		@name = "Level One"
		@gamecontext = gamecontext

		@player = @gamecontext.player

		@asteroid_frequency = asteroid_frequency = @gamecontext.config["leveltwo"]["asteroid_frequency"]
		@asteroid_slow_speed = @gamecontext.config["leveltwo"]["asteroid_slow_speed"].to_i
		@asteroid_fast_speed = @gamecontext.config["leveltwo"]["asteroid_fast_speed"].to_i
		@speed_ratio = @gamecontext.config["leveltwo"]["speed_ratio"].to_i
		reset()

		@name = "Level 2 - Asteroid Field"
	end

	def reset()

		@number_asteroids_passed = 0
		@destroyed = 0
		@appeared = 0
		@asteroids.clear()
		@bullets.clear()
		@explosions.clear()
		@player.reset(@gamecontext.window_attributes["center"])
	end

	def draw

		@player.draw

		@asteroids.each do |e|
			e.draw
		end

		@bullets.each do |b|
			b.draw
		end

		@explosions.each do |e|
			e.draw
		end

		return collision_detection()
	end

	def update
		
		rand_num = rand()
		
		# Determine how many asteroids to produce
		
		if rand_num < @asteroid_frequency

			rand_speed = rand()

			if rand_speed < @speed_ratio
				@asteroids << Asteroid.new(@gamecontext, @asteroid_slow_speed)
			else
				@asteroids << Asteroid.new(@gamecontext, @asteroid_fast_speed)
			end
		end

		# No escape penalty as such for asteroids
		@asteroids.each do |e|
			e.move
			if e.escaped?
				@number_asteroids_passed += 1
				e.respawn()
			end
		end

		@bullets.each do |b|
			b.move
		end

		return collision_detection()
	end

	def collision_detection

		@asteroids.dup().each do |e|
			if e.y > @gamecontext.window_attributes["height"] + e.radius
				@asteroids.delete e
			end
		end

		# Collision detection for player
		@asteroids.each do |e|
			
			distance = Gosu::distance(e.x, e.y, @player.x, @player.y)
			if distance < @player.radius + e.radius
				@gamecontext.sounds["explosion"].play()
				return :level_failed, "You were hit by an asteroid!"
			end
		end

		if @player.y < -@player.radius
			return :level_failed, "You left your base and were destroyed!"
		end

		return :no_action_to_take
	end

	def complete() 

		# Change to num destroyed
		complete_threshold = @gamecontext.config["leveltwo"]["num_asteroids_pass_to_complete"]
		complete = @number_asteroids_passed.eql? complete_threshold
		return complete
	end

	def handle_button_down(id)
		# NOOP
	end

	def objective_score_msgs()
		return ["Asteroids Negotiated: #{@number_asteroids_passed}"]
	end
end