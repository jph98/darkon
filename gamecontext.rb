#!/usr/bin/env ruby

require_relative "levelone"
require_relative "leveltwo"

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