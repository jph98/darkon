#!/usr/bin/env ruby
class Credit

	SPEED = 1
	attr_reader :y

	def initialize(window, score, y)
		@window = window
		@score = score
		@initial_y = y
		@y = y
		@font = Gosu::Font.new(30)
	end

	def move
		@y -= SPEED
	end

	def draw
		@font.draw("#{@score[:pos]}", 100, @y, 1)
		@font.draw(@score[:name].upcase.chop, 160, @y, 1)
		@font.draw(@score[:score].upcase.chop, 260, @y, 1)
	end

	def reset
		@y = @initial_y
	end
end