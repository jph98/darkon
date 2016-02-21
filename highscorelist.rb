#!/usr/bin/env ruby

require "ostruct"

class HighScoreList

	attr_accessor :entries

	FILENAME = "highscorelist.txt"
	MAX_SIZE = 10

	def initialize()

		lines = File.foreach(FILENAME)

		@entries = []

		lines.each_with_index do |l, n|
			pos = l.split(",")[0]
			name = l.split(",")[1]
			score = l.split(",")[2]
			entry = OpenStruct.new(:pos => pos, :name => name, :score => score)
			@entries << entry
		end
	end

	def save_if_high_score(name, score)
		
		@entries.push(OpenStruct.new(:pos => @entries.size() + 1, :name => name, :score => score.to_i))

		new_entries = @entries.sort_by { |e| 
			e[:score].to_i
		}.reverse

		# Only keep MAX_SIZE scores in list
		if new_entries.size > MAX_SIZE
			new_entries.pop()
		end

		# Write scores back to file, reindex
		File.open(FILENAME, 'w') do |f| 
			new_entries.each_with_index do |e, i|
				f.puts "#{i+1},#{e[:name]},#{e[:score]}"
			end
		end
	end

end