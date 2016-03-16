#!/usr/bin/env ruby

class EnemyArc

	DEBUG = false
	
	attr_reader :x, :y, :radius

	def initialize(gamecontext, speed, start_x, start_y, target_coords_list)

		@radius = 20
		@width = gamecontext.window_attributes["width"]
		@height = gamecontext.window_attributes["height"]

		@x = start_x
		@y = start_y

		@target_coords_list = target_coords_list

		# Get from the config (or is this contextual within the level?)
		@speed = speed
		@image = Gosu::Image.new("images/enemy.png")

		@angle = 180				
		puts "Placed enemy at: #{@x}, #{@y}" if DEBUG
	end

	def draw
		@image.draw_rot(@x - @radius, @y - @radius, 1, @angle)
	end

	def move

		# See: http://xboxforums.create.msdn.com/forums/t/5723.aspx
		# See: http://answers.unity3d.com/questions/363810/how-to-move-an-enemy-on-a-curvy-line.html
		# See: http://www.gamedev.net/topic/575982-making-an-enemy-move-in-a-sine-wave-pattern/
		# Angular Frequency, Simple Harmonic Motion, Euclidean Geometry
		# @target_coords_list.each do |pair|

		# 	# TODO: Move to each pair

		# end
		@y = 2 * Math::sin(@x / 2)
	end

	def escaped?
		return @y > @height + @radius
	end

	def respawn
	end
end