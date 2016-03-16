#!/usr/bin/env ruby

class EnemyCannon

	DEBUG = false
	
	attr_reader :x, :y, :radius

	def initialize(gamecontext, speed, x, y)

		@radius = 20
		@gamecontext = gamecontext
		@width = gamecontext.window_attributes["width"]
		@height = gamecontext.window_attributes["height"]
		@player = @gamecontext.player
		@x = x
		@y = y

		# Get from the config (or is this contextual within the level?)
		@cannon = Gosu::Image.new("images/cannon.png")

		puts "Placed cannon at: x:#{@x} y:#{@y}"
		puts "Tracking player at x:#{@gamecontext.player.x} y:#{@gamecontext.player.y}"
	end

	def draw

		@cannon.draw_rot(@x, @y, z = 1, angle = calculate_angle())

		if @bullet != nil and @bullet.on_screen?
			@bullet.draw()
		else
			angle = calculate_angle()
			@bullet = Bullet.new(@gamecontext, x, y, angle)			
		end		
	end

	def move
		if @bullet != nil
			@bullet.move()	
		end	
		#@y += 1
	end

	def escaped?
	end

	def respawn
	end

	def calculate_angle()	

		l_x = 0
		if (@x > @player.x)
			l_x = -(@x - @player.x)
		else
			l_x = @player.x - @x
		end

		l_y = 0
		if (@y > @player.y)
			l_y = -(@y - @player.y)
		else
			l_y = @player.y - @y
		end

		angle_rads = Math::atan2(l_y, l_x)
		angle_degs = ((angle_rads * 180) / Math::PI) + 90

		puts "cannon x: #{@x} cannon y: #{@y}"
		puts "player x: #{@player.x} player y: #{@player.y}"
		puts "l_x:#{l_x} and l_y:#{l_y}"		
		puts "Angle Rads: #{angle_rads}"
		puts "Angle Degs: #{angle_degs}"

		return angle_degs
	end

end