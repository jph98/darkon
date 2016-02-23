#!/usr/bin/env ruby

class LevelOne

	attr_accessor :destroyed, :name

	def initialize(gamecontext)

		@enemies = []
		@bonus_items = []
		@bullets = []
		@explosions = []
		@gamecontext = gamecontext

		@player = @gamecontext.player

		@max_threshold = @gamecontext.config["levelone"]["max_num_ships_that_can_escape"]
		@enemy_frequency = @gamecontext.config["levelone"]["enemy_frequency"]
		@bonus_item_frequency = @gamecontext.config["levelone"]["bonus_item_frequency"]
		@slow_speed = @gamecontext.config["levelone"]["enemy_slow_speed"]
		@fast_speed = @gamecontext.config["levelone"]["enemy_slow_speed"]
		@speed_ratio = @gamecontext.config["levelone"]["speed_ratio"]

		reset()

		@bg_image = Gosu::Image.new("images/bg_game_image.png")

		@name = "Level 1 - Attack Ships"
		
		@bg_x = 0
		@bg_y = 0
	end

	def reset()

		@number_ships_escaped = 0
		@destroyed = 0
		@appeared = 0
		@escaped = 0
		@player.reset(@gamecontext.window_attributes["center"])
		@enemies.clear()
		@bullets.clear()
		@explosions.clear()
		@bonus_items.clear()
	end

	def draw

		@bg_image.draw(@bg_x, @bg_y, 0)

		@player.draw

		@enemies.each do |e|
			e.draw
		end

		@bullets.each do |b|
			b.draw
		end

		@bonus_items.each do |bi|
			bi.draw
		end

		@explosions.each do |e|
			e.draw
		end

		collision_detection()		
	end

	def update()

		@bg_y += 1

		rand_enemy_num = rand()

		# Determine how many enemies to produce
		if rand_enemy_num < @enemy_frequency			

			rand_speed = rand()
			if rand_speed < @speed_ratio	
				@enemies << Enemy.new(@gamecontext, @slow_speed)
			else
				@enemies << Enemy.new(@gamecontext, @fast_speed)
			end

			@appeared += 1
		end

		rand_bonus_item_num = rand()
		if rand_bonus_item_num < @bonus_item_frequency
			@bonus_items << BonusItem.new(@gamecontext, @fast_speed)
		end

		@enemies.each do |e|
			e.move

			# If the enemy makes it to the bottom of the screen
			if e.escaped?
				@escaped += 1
				e.respawn()
			end
		end

		@bonus_items.each do |b|
			b.move
		end

		@bullets.each do |b|
			b.move
		end

		return collision_detection()
	end

	def handle_button_down(id)

		if id == Gosu::KbSpace
			@bullets << Bullet.new(@gamecontext, @player.x, @player.y, @player.angle)
			@gamecontext.sounds["shoot"].play(0.3)
		end
	end

	def objective_score_msgs()
		return ["Escaped: #{@escaped}", "Destroyed: #{@destroyed}"]
	end

	def collision_detection

		@enemies.dup().each do |e|

			@bullets.each do |b|

				distance = Gosu.distance(e.x, e.y, b.x, b.y)

				if distance < e.radius + b.radius
					@enemies.delete	e
					@bullets.delete b
					@explosions << Explosion.new(@gamecontext, e.x, e.y)
					@gamecontext.sounds["explosion"].play()
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
		
		if @escaped > @max_threshold	
			return :level_failed, "#{@max_threshold} ships escaped, base destroyed!" 
		end

		# Collision detection for player
		@enemies.each do |e|
			
			distance = Gosu::distance(e.x, e.y, @player.x, @player.y)
			if distance < @player.radius + e.radius
				@gamecontext.sounds["explosion"].play()
				return :level_failed, "You were hit by an enemy ship"
			end
		end

		@bonus_items.dup().each do |bi|
			distance = Gosu::distance(bi.x, bi.y, @player.x, @player.y)
			if distance < @player.radius + bi.radius

				@gamecontext.sounds["bonusitemcollected"].play()				
				@bonus_items.delete bi

				if bi.type.eql? BonusItem::LOOT
					@gamecontext.scoreboard.points += 25
				elsif bi.type.eql? BonusItem::SPEEDUP
					@gamecontext.player.acceleration = 0.7
					@gamecontext.player.rotation_speed = 5
				end
			end						
		end

		if @player.y < -@player.radius
			return :level_failed, "You left your base and were destroyed!"
		end

		return :no_action_to_take
	end


	def complete() 

		complete = @destroyed.eql? @gamecontext.config["levelone"]["ships_destroyed_to_complete"]
		return complete
	end

end