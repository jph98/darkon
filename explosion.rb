#!/usr/bin/env ruby

class Explosion

	attr_reader :x, :y, :radius, :finished

	def initialize(gamecontext, x, y)

		@x = x
		@y = y
		@radius = 30
		@images = Gosu::Image.load_tiles('images/explosions.png', 60, 60)
		@image_num = 0
		@finished = false
		@gamecontext = gamecontext
	end

	def draw

		#@image.draw(@x - @radius, @y - @radius, 1)
		if @image_num < @images.size()
			@images[@image_num].draw(@x - @radius, @y - @radius, 2)
			@image_num += 1
		else
			finished = true
		end

	end

end