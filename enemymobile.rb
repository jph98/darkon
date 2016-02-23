#!/usr/bin/env ruby

class EnemyMobile

	DEBUG = false
	
	attr_reader :x, :y, :radius

	def initialize(gamecontext, speed)

		# Randomize placement
		@radius = 20
		@width = gamecontext.window_attributes["width"]
		@height = gamecontext.window_attributes["height"]

		@x = rand(@width - 2 * @radius ) + @radius
		@y = 0

		# Get from the config (or is this contextual within the level?)
		@speed = speed
		@image = Gosu::Image.new("images/enemy.png")
		@angle = 360

		@current_direction = :down
		@travelled = 0
		puts "Placed enemy at: #{@x}, #{@y}" if DEBUG
	end

	def draw
		@image.draw(@x - @radius, @y - @radius, 1)
	end

	def move

		# TODO: Edge detection as part of this
		case @current_direction
			when :down			
				@y += @speed
				change_direction_after_travelling(40, @speed, [:left, :right])
			when :right
				@x += @speed
				change_direction_after_travelling(40, @speed, [:left, :down])
			when :left
				@x -= @speed
				change_direction_after_travelling(40, @speed, [:down, :right])
		end
	end

	def change_direction_after_travelling(amount, speed, directions)

		@travelled += speed

		if @travelled > amount
			rand_dir = rand()
			if rand_dir > 0.10
				@current_direction = directions[0]
			else
				@current_direction = directions[1]
			end
			@travelled = 0
		end
	end

	def right_edge?
		return @x >= (@width - @radius)
	end

	def left_edge?
		return @x >= (0 + @radius)
	end

	def escaped?
		return @y > @height + @radius
	end

	def respawn
		@x = rand(@width - 2 * @radius) + @radius
		@y = 0
	end
end