#!/usr/bin/env ruby

class Player

	attr_accessor :x, :y, :angle, :radius, :name, :acceleration, :rotation_speed

	def initialize(name, config, windowattributes)

		@x = config["player"]["start_pos_x"]
		@y = config["player"]["start_pos_x"]
		@angle = 0 # degrees
		@image = Gosu::Image.new("images/ship.png")
		@v_x = 0 # velocity
		@v_y = 0
		@radius = 8
		@acceleration = config["player"]["acceleration"]
		@friction = config["player"]["friction"]
		@rotation_speed = config["player"]["rotation_speed"]
		@name = name
		@windowattributes = windowattributes
	end

	def accelerate

		@v_x += Gosu.offset_x(@angle, @acceleration)
		@v_y += Gosu.offset_y(@angle, @acceleration)
	end

	def backwards

		@v_x -= Gosu.offset_x(@angle, @acceleration)
		@v_y -= Gosu.offset_y(@angle, @acceleration)
	end

	def move

		@x += @v_x
		@y += @v_y
		@v_x *= @friction
		@v_y *= @friction

		boundary_checks()
	end

	def boundary_checks() 

		if @x > (@windowattributes["width"] - @radius)
			@v_x = 0
			@x = (@windowattributes["width"] - @radius)
		end
		
		if @x < @radius
			@v_x = 0
			@x = @radius
		end

		if @y > (@windowattributes["height"] - @radius)
			@v_y = 0
			@y = (@windowattributes["height"] - @radius)
		end
	end

	def reset(x)
		@x = x
		@y = 380
	end

	def turn_right

		@angle += @rotation_speed
	end

	def turn_left

		@angle -= @rotation_speed
	end

	def draw

		@image.draw_rot(@x, @y, 1, @angle)
	end

end