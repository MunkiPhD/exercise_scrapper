require 'rubygems'
require 'open-uri'
require 'mechanize'
require 'json'
require_relative 'details_parser'
require_relative 'exercise_scrapper'

puts 'script starting'
puts '--------------------------------------------'


module WriteToJsonFile
	def self.write_array(arr, filename)
		File.open(filename, 'w') do |f|
			f.write(arr.to_json)
		end
	end
end


# we start off on the 0-9 listing page because there are only two exercises there (ones that no one cares about really) and the # in the links throws the parsing off
url = 'http://www.bodybuilding.com/exercises/list/index/selected/0-9'
scrapper = ExerciseScrapper.new(url)
@data = scrapper.scrape
WriteToJsonFile.write_array(@data, "exercise_data.json")

puts '--------------------------------------------'
puts 'script ended!'
