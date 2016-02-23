#!/usr/bin/env ruby

class SceneManager

	attr_accessor :current, :scenelist

	def initialize()

		@scenelist = []		
	end

	def first() 

		@current = @scenelist.first()
	end

	def reset()

		@scenelist.each do |s|
			s.reset()
		end
	end

	def next()

		pos = @scenelist.index(@current)
		end_pos = @scenelist.size - 1
		if pos.eql? (end_pos)
			return :end_of_game
		else 
			pos += 1
			@current = @scenelist[pos]
			return @scenelist[pos]
		end
	end
end