#!/usr/bin/env ruby

class LevelIntro

	attr_accessor :destroyed, :name

	def initialize(window, gamecontext, name, msg)

		@gamecontext = gamecontext
		@window = window
		@name = name
		@msg = msg
		@center = @gamecontext.window_attributes["center"].to_i
		@height = @gamecontext.window_attributes["height"].to_i
		@proceed = false

		@bg = Gosu::Image.new("images/bg_game_image.png")
		@bg_y = 0

		# @bg_layer = Gosu::Image.new("images/bg_overlay.png")
		# @bg_layer_y = 0
	end

	def reset()
	end

	def draw

		# Background render		
		@local_y = @bg_y % -@height
	    @bg.draw(0, @local_y, 0)
	    if @local_y < 0
	      @bg.draw(0, @local_y + @height, 0) 
	    end

	    # @local_layer_y = @bg_layer_y % -@height
	    # @bg_layer.draw(0, @local_layer_y, 0)
	    # if @local_layer_y < 0
	    #   @bg_layer.draw(0, @local_layer_y + @height, 0) 
	    # end

		draw_center(@name, 50, @gamecontext.colors["orange"], @center, 250) 
		draw_center(@msg, 20, @gamecontext.colors["white"], @center, 300) 		
		draw_center("Press any key to start", 20, @gamecontext.colors["white"], @center, 340) 		

	end

	def draw_center(text, font_size, color, x_pos, y_pos) 

		i = Gosu::Image.from_text(@window, text, Gosu.default_font_name, font_size)
		i.draw_rot(x = x_pos, y = y_pos, z = 0, angle = 0, 
					center_x = 0.5, center_y = 0.5, 
					scale_x = 1, scale_y = 1,
					color = color)
	end

	def update()
		@bg_y += 3
		#@bg_layer_y += 1
	end

	def handle_button_down(id)
		
		@proceed = true
	end

	def objective_score_msgs()
		return []
	end

	def complete() 

		return @proceed
	end

end