#!/usr/bin/env ruby

class LevelIntro

	attr_accessor :destroyed, :name

	def initialize(window, gamecontext, name, msg)

		@gamecontext = gamecontext
		@window = window
		@name = name
		@msg = msg
		@center = @gamecontext.window_attributes["center"].to_i
		@proceed = false
	end

	def reset()
	end

	def draw

		draw_center(@name, 50, @gamecontext.colors["orange"], @center, 250) 
		draw_center(@msg, 20, @gamecontext.colors["white"], @center, 300) 		
		draw_center("Press enter to start", 20, @gamecontext.colors["white"], @center, 340) 		
	end

	def draw_center(text, font_size, color, x_pos, y_pos) 

		i = Gosu::Image.from_text(@window, text, Gosu.default_font_name, font_size)
		i.draw_rot(x = x_pos, y = y_pos, z = 0, angle = 0, 
					center_x = 0.5, center_y = 0.5, 
					scale_x = 1, scale_y = 1,
					color = color)
	end

	def update()
	end

	def handle_button_down(id)
		
		if id.eql? Gosu::KbReturn or id.eql? Gosu::KbEnter
			@proceed = true
		end
	end

	def objective_score_msgs()
		return []
	end

	def complete() 

		return @proceed
	end

end