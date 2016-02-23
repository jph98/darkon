#!/usr/bin/env ruby

class GameContext

	attr_accessor :player, :window_attributes, :config, :sounds, :scoreboard, :colors, :window

	def initialize(player, window_attributes, config, sounds, scoreboard, colors)

		@player = player
		@window_attributes = window_attributes
		@config = config
		@sounds = sounds
		@scoreboard = scoreboard
		@colors = colors
	end
end