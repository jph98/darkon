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
		# @images = Gosu::Image.load_tiles('images/asteroid.png', 40, 33)
		# @image_num = 0
		# @finished = false

		# @angle = 360

		puts "Placed asteroid at: #{@x}, #{@y}" if DEBUG

		@frame = 0
		@prev_rot = -1
	end

	def draw
		# if @image_num < @images.size()
		# 	@images[@image_num].draw(@x - @radius, @y - @radius, 2)
		# 	@image_num += 1
		# else
		# 	finished = true
		# end

		#@image.draw(@x - @radius, @y - @radius, 1)

		if (@prev_rot.eql? -1)

			# Rotate up to 20 degs
			@prev_rot = 0 + (rand() * 20)
			@image.draw_rot(x = @x - @radius, y = @y - @radius, 1, @prev_rot)
			
		elsif (@frame % 2).eql? 1

			# Rotate up to 20 degs
			@prev_rot = @prev_rot + 20
			if @prev_rot > 360
				@prev_rot = 0
			end
			@image.draw_rot(x = @x - @radius, y = @y - @radius, 1, @prev_rot)
		else
			# Just draw in same rotated position
			@image.draw_rot(x = @x - @radius, y = @y - @radius, 1, @prev_rot)
		end
		
		@frame += 1
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