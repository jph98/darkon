#!/usr/bin/env ruby

require "gosu"
require "yaml"

require_relative "player"
require_relative "enemy"
require_relative "asteroid"
require_relative "bullet"
require_relative "explosion"
require_relative "scoreboard"
require_relative "highscorelist"
require_relative "credit"
require_relative "scenemanager"
require_relative "gamecontext"

#
# Website: https://www.libgosu.org/
# Docs: https://www.libgosu.org/rdoc/
# Gosu Class: https://www.libgosu.org/rdoc/Gosu.html
# Color: https://www.libgosu.org/rdoc/Gosu/Color.html
#
class FireAttack < Gosu::Window 

	WIDTH = 800
	HEIGHT = 600

	CENTER = (WIDTH / 2)	

	def initialize

		@config = YAML.load_file("config.yml")
		super(WIDTH, HEIGHT, fullscreen = @config["fullscreen"])
		self.caption = "Fire Attack"
		
		@max_enemies_before_game_end = @config["game"]["max_enemies_before_game_end"]

		@background_image = Gosu::Image.new("images/start_screen.png")
		@scene = :start

		@scoreboard = ScoreBoard.new()
		@score_font = Gosu::Font.new(28)

		@highscorelist = HighScoreList.new()	

		@intro_music = Gosu::Song.new('sounds/darkon.ogg')
		@intro_music.play(true)

		y = 700
		@credits = []
		@highscorelist.entries.each do |cred|
			@credits.push(Credit.new(self, cred, y))
			y += 40
		end

		# Load the sound effects
		sounds = {}
		sounds["explosion"] = Gosu::Sample.new('sounds/explosion.wav')
		sounds["shoot"] = Gosu::Sample.new('sounds/shoot.ogg')
		sounds["levelonemsuic"] = Gosu::Song.new('sounds/krkk.ogg')

		sounds["levelonemsuic"].play(true)
 
		# Move to player/gamecontext
		@name = "jon"			

		# Move @config to gamecontext
		
		@window_attributes = {}
		@window_attributes["width"] = WIDTH
		@window_attributes["height"] = HEIGHT
		@window_attributes["center"] = CENTER

		# Init player with specifics, need to pass to gamecontext for everything else
		@player = Player.new(@name, @config, @window_attributes)
		@gamecontext = GameContext.new(@player, @window_attributes, @config, sounds)
		
		# Setup levels
		@scenemanager = SceneManager.new()		
		@scenemanager.scenelist << LevelOne.new(@gamecontext)
		@scenemanager.scenelist << LevelTwo.new(@gamecontext)
		@scenemanager.first()
	end

	# Gosu @override
	def draw

		case @scene

			when :start
				draw_start_screen

			when :end
				draw_end_scene
			else
				
				@scene.draw()
				draw_score()

				if @scene.complete()

					@scene = @scenemanager.next()
					if @scene.eql? :end_of_game
						initialize_end(:end_of_game, "Congratulations Commander!")
					end
				end
		end

	end

	# Gosu @override
	def update()

		case @scene
			when :start
				# Move this to scenemanager eventually
				update_start_scene
			when :end
				# Move this to scenemanager eventually
				update_end_scene
			else

				# Moved buttons?
				@player.turn_left if button_down?(Gosu::KbLeft) 
				@player.turn_right if button_down?(Gosu::KbRight) 
				@player.accelerate if button_down?(Gosu::KbUp)

				@player.move()

				action, message = @scene.update()

				if action.eql? :point_scored
					@scoreboard.points += 10
				elsif action.eql? :level_failed
					initialize_end(:level_failed, message)
				end
		end

	end

	def draw_start_screen

		@background_image.draw(0,0,0)

		# colors, see - http://www.nthelp.com/colorcodes.htm

		title_msg = "Fire Attack" # orange
		draw_center(title_msg, 55, 0xffff9933, CENTER, 90) 

		strap_msg = "Mission control defence edition" # white
		draw_center(strap_msg, 22, 0xff808080, CENTER, 130) 

		enemy = Gosu::Image.new("images/enemy.png")
		start_x = (WIDTH / 4)
		9.times do |i|
			enemy.draw_rot(x = start_x + (i * 50), y = 235, z = 0, angle = 0)
		end

		obj_msg = "Objective: Destroy as many enemies before 100 of them reach the base"
		draw_center(obj_msg, 20, 0xffffffff, CENTER, 300) # white

		ctl_msg = "Arrow keys to move, space to fire" # yellow
		draw_center(ctl_msg, 20, 0xffffffff, CENTER, 340) 

		@player.reset(CENTER)
		@player.draw
		
		draw_center("Name: " + @player.name, 20, 0xffffff00, CENTER, 430) 

		name_msg = "Hit the enter key to start"
		draw_center(name_msg, 16, 0xffffffff, CENTER, 460) 
	end

	def draw_center(text, font_size, color, x_pos, y_pos) 

		i = Gosu::Image.from_text(self, text, Gosu.default_font_name, font_size)
		i.draw_rot(x = x_pos, y = y_pos, z = 0, angle = 0, 
					center_x = 0.5, center_y = 0.5, 
					scale_x = 1, scale_y = 1,
					color = color)
	end

	def update_start_scene
		
		@player.turn_left if button_down?(Gosu::KbLeft) 
		@player.turn_right if button_down?(Gosu::KbRight) 		
	end

	# Gosu @override
	def button_down(id)

		# TODO: Put in level screens
		case @scene

		when :start
			button_down_start(id)		
		when :end
			button_down_end(id)
		else
			@scene.handle_button_down(id)
		end
	end

	# Move to LevelStart
	def button_down_start(id) 

		if id.eql? Gosu::KbReturn or id.eql? Gosu::KbEnter

			# Set scene to the current/first one
			@scene = @scenemanager.current

		elsif id.eql? Gosu::KbDelete or id.eql? Gosu::KbBackspace
			@player.name = @player.name.chop
		elsif id >= 4 and id <= 29 or id.eql? Gosu::KbSpace
			@player.name += button_id_to_char(id)
		end
	end

	def draw_score() 

		score_msg_y = 40
		@score_font.draw("Score: #{@scoreboard.points}", x = 40, y = score_msg_y, 1, 1, 1, Gosu::Color.new(0xff_ffff00))

		msgs = @scene.objective_score_msgs()
		msgs.each do |m|
			score_msg_y += 40
			@score_font.draw(m, x = 40, y = score_msg_y, 1, 1, 1, Gosu::Color.new(0xff_ff0000))
		end
	end

	#
	# END
	#
	def initialize_end(end_scenario, message)

		case end_scenario

			when :level_failed
				@message = message				

			when :end_of_game
				@message = message
			else 
				# Testing really
				@message = "Unknown"
			
			@message2 = "Score: #{@scoreboard.points}"
		end

		@highscorelist.save_if_high_score(@player.name, @scoreboard.points)
		@highscorelist = HighScoreList.new()

		@bottom_message = "Press P to play again or Q to quit"		

		@message_font = Gosu::Font.new(28)

		@scene = :end
		@scoreboard.reset()
		@player.reset(CENTER)
	end

	def draw_end_scene

		# Read the credits from the text bundle resource
		clip_to(50, 140, 700, 360) do 
			@credits.each do |cred|
				cred.draw
			end
		end

		# Draw a divider
		red = Gosu::Color.new(0xff_ff0000)
		draw_line(0, 140, red, WIDTH, 140, red)

		# Draw both messages on the screen
		yellow = Gosu::Color.new(0xff_ffff00)
		@message_font.draw(@message, 40, 40, 1, 1, 1, yellow)
	  	@message_font.draw(@message2, 40, 75, 1, 1, 1, yellow)

	  	# Draw a divider	  	
	  	draw_line(0, 500, red, WIDTH, 500, red)

	  	# Draw the bottom message (for play or quit)
	  	green = Gosu::Color.new(0xff_00ff00)
	  	@message_font.draw(@bottom_message, 180, 540, 1, 1, 1, green)

	end

	def update_end_scene
		
		@credits.each do |c|
			c.move
		end
		if @credits.last.y < 150
			@credits.each do |c|
				c.reset
			end
		end
	end

	def button_down_end(id) 

		# Play
		if id == Gosu::KbP			
			@scene = :start
			@scenemanager.reset()
			@scenemanager.first()			
			puts "Set #{@scenemanager.current.name}"
		elsif id == Gosu::KbQ
			# Quit
			close
		end 
	end

end

window = FireAttack.new
window.show