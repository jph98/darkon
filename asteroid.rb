#!/usr/bin/env ruby

class Asteroid

	DEBUG = false
	
	attr_reader :x, :y, :radius

	def initialize(gamecontext, speed)

		# TODO: Randomize placement
		@radius = 20

		@gamecontext = gamecontext
		@x = rand(@gamecontext.window_attributes["width"] - 2 * @radius ) + @radius
		@y = 0

		@speed = speed

		# Use rand_num to choose
		# a) An image (3 different sizes)
		# b) A rotation
		@image = Gosu::Image.new("images/asteroid.png")
		@angle = 360

		puts "Placed asteroid at: #{@x}, #{@y}" if DEBUG
	end

	def draw
		@image.draw(@x - @radius, @y - @radius, 1)
	end

	def move
		@y += @speed
	end

	def escaped?
		return @y > @gamecontext.window_attributes["height"] + @radius
	end

	def respawn
		@x = rand(@gamecontext.window_attributes["width"] - 2 * @radius) + @radius
		@y = 0
	end
end