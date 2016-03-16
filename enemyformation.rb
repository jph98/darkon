#!/usr/bin/env ruby

class EnemyFormation

	DEBUG = false
	
	attr_reader :radius, :enemies

	# Arrangement is an array of enemy frequency per line
	def initialize(gamecontext, arrangement)

		@gamecontext = gamecontext
		@width = @gamecontext.window_attributes["width"]
		@height = @gamecontext.window_attributes["height"]

		@enemies = []
		y = 40
		interval_x = 40
		interval_y = 40
		arrangement.each do |num_per_row|	

			formation_width = (num_per_row * interval_x)
			mid_x = @width / 2
			start_x = mid_x - (formation_width / 2)
			puts "num per row: #{num_per_row}"
			(1..num_per_row).each do |n|							
				speed = 2
				es = EnemySpixon.new(@gamecontext, speed, start_x ,y)				
				@enemies << es
				start_x += interval_x
			end
			y += interval_y
		end

		@enemies.each do |e|
			puts "Name: #{e.name}"
		end
	end

	def draw
		@enemies.each do |e|
			e.draw()
		end
	end

	def move
		@enemies.each do |e|
			e.move()
		end
	end

	def escaped?
		@enemies.each do |e|
			return e.escaped?
		end
	end

	def respawn
		@enemies.each do |e|
			return e.respawn
		end
	end
end