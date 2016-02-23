#!/usr/bin/env ruby

class BonusItem

	DEBUG = false

	LOOT = "loot"
	SPEEDUP = "speedup"
	
	attr_reader :x, :y, :radius, :type

	def initialize(gamecontext, speed)

		# Randomize placement
		@radius = 20
		@width = gamecontext.window_attributes["width"]
		@height = gamecontext.window_attributes["height"]

		@x = rand(@width - 2 * @radius ) + @radius
		@y = 0

		@speed = speed

		rand_type = rand()
		puts rand_type
		if rand_type < gamecontext.config["levelone"]["bonus_item_type_frequency"]
			@image = Gosu::Image.new("images/bonusitem-speedup.png")
			@type = SPEEDUP
		else
			@image = Gosu::Image.new("images/bonusitem-loot.png")
			@type = LOOT
		end
		@angle = 360

		puts "Placed bonus item at: #{@x}, #{@y}" if DEBUG
	end

	def draw
		@image.draw(@x - @radius, @y - @radius, 1)
	end

	def move
		@y += @speed		
	end

	def respawn
		@x = rand(@width - 2 * @radius) + @radius
		@y = 0
	end
end