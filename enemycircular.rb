#!/usr/bin/env ruby

class EnemyCircular

	DEBUG = false
	
	attr_reader :x, :y, :radius

	def initialize(gamecontext, speed, x, y)

		@radius = 20
		@width = gamecontext.window_attributes["width"]
		@height = gamecontext.window_attributes["height"]

		@x = x
		@y = y

		# Get from the config (or is this contextual within the level?)
		@speed = speed
		@orbit_speed = 2
		@enemy = Gosu::Image.new("images/enemy.png")

		# Enemy image points up, so flip (rotate by 180 degrees)
		@angle = 180

		puts "Placed enemy at: #{@x}, #{@y}" if DEBUG

		@mode = :approach
		@player = gamecontext.player

		@fixed_distance_from_player = 100
		@orbit_radius = 100 
	end

	def draw

		unless escaped?
			if @mode.eql? :approach
				@enemy.draw_rot(@x, @y, z = 1, @angle)
			elsif @mode.eql? :orbit
				@enemy.draw_rot(@x, @y, z = 1, angle = calculate_angle())
			else
				@enemy.draw_rot(@x, @y, z = 1, @angle)
			end
		end
	end

	def move

		# Move to a fixed point away from player
		if @mode.eql? :approach
			distance = @player.y - @y
			if distance > @fixed_distance_from_player				
				@y += @speed
			else distance.eql? @fixed_distance_from_player
				@mode = :orbit
				# Peculiar but required to maintain position before orbit
				@angle = -90
			end

		elsif @mode.eql? :orbit

			@angle += @orbit_speed
			rad = @angle * (Math::PI / 180)
			@x = @player.x + @orbit_radius * Math::cos(rad)
			@y = @player.y + @orbit_radius * Math::sin(rad)
			puts "\n\nx: #{@x} y: #{@y} angle: #{@angle}\n\n" if DEBUG
			if @angle >= 270
				@mode = :backoff
			end

		elsif @mode.eql? :backoff

			@y -= @speed
			@angle = 180
			
		else
			puts "\n\nx: #{@x} y: #{@y} angle: #{@angle}\n\n" if DEBUG
		end
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

		# Radians = Degrees * (PI / 180)
		angle_rads = Math::atan2(l_y, l_x)

		# Degrees = Radians * 180 / PI
		angle_degs = ((angle_rads * 180) / Math::PI) + 90

		puts "cannon x: #{@x} cannon y: #{@y}" if DEBUG
		puts "player x: #{@player.x} player y: #{@player.y}" if DEBUG
		puts "l_x:#{l_x} and l_y:#{l_y}" if DEBUG
		puts "Angle Rads: #{angle_rads}" if DEBUG
		puts "Angle Degs: #{angle_degs}" if DEBUG

		return angle_degs
	end

	def escaped?
		if @y > @height + @radius
			return true
		elsif @y < 0 + @radius
			return true
		end
		return false
	end

	def respawn
	end
end