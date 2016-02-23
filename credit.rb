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

		@font.draw("#{@score[:pos]}", 230, @y, 1)

		name = @score[:name].upcase
		if name.include? "\n"
			name = name.chop
		end
		@font.draw(name, 280, @y, 1)

		score = @score[:score].upcase
		if score.include? "\n"
			score = score.chop
		end
		@font.draw(score, 500, @y, 1)
	end

	def draw_center(text, font_size, color, x_pos, y_pos) 

		i = Gosu::Image.from_text(@window, text, Gosu.default_font_name, font_size)
		i.draw_rot(x = x_pos, y = y_pos, z = 0, angle = 0, 
					center_x = 0.5, center_y = 0.5, 
					scale_x = 1, scale_y = 1,
					color = color)
	end

	def reset
		@y = @initial_y
	end
end