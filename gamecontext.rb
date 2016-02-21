#!/usr/bin/env ruby

require_relative "levelone"
require_relative "leveltwo"

class GameContext

	attr_accessor :player, :window_attributes, :config, :sounds

	def initialize(player, window_attributes, config, sounds)

		@player = player
		@window_attributes = window_attributes
		@config = config
		@sounds = sounds
	end
end