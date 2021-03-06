#!/usr/bin/env ruby

class EnemyFire

	DEBUG = false
	
	attr_reader :x, :y, :radius

	def initialize(gamecontext, speed)

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
		
	end

	def escaped?
		return @y > @height + @radius
	end

	def respawn
		@x = rand(@width - 2 * @radius) + @radius
		@y = 0
	end
end