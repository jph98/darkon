#!/usr/bin/env ruby

class Bullet

	SPEED = 5

	attr_reader :x, :y, :radius

	def initialize(gamecontext, x, y, angle)

		@x = x
		@y = y
		@image = Gosu::Image.new("images/bullet.png")
		@direction = angle
		@radius = 3
		@gamecontext = gamecontext
	end

	def move

		@x += Gosu.offset_x(@direction, SPEED)
		@y += Gosu.offset_y(@direction, SPEED)
	end

	def draw

		@image.draw(@x - @radius, @y - @radius, 1)
	end

	def on_screen?

		right = @gamecontext.window_attributes["width"] - @radius
		left = -@radius
		top = -@radius
		bottom = @gamecontext.window_attributes["height"] + @radius
		@x > left and @x < right and @y > top and @y < bottom
	end

end