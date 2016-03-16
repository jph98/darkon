#!/usr/bin/env ruby

class EnemySpixon

	DEBUG = false
	
	attr_reader :x, :y, :radius, :name

	def initialize(gamecontext, speed, x, y)

		@name = "Spixon"
		
		@radius = 20
		@width = gamecontext.window_attributes["width"]
		@height = gamecontext.window_attributes["height"]

		@x = x
		@y = y

		# Get from the config (or is this contextual within the level?)
		@speed = speed
		@image = Gosu::Image.new("images/enemy.png")
		@angle = 360

		puts "Placed enemy at: #{@x}, #{@y}" if DEBUG
	end

	def draw
		@image.draw(@x - @radius, @y - @radius, 1)
	end

	def move
		@y += @speed		
	end

	def escaped?
		return @y > @height + @radius
	end

	def respawn		
		@y = 0
	end
end