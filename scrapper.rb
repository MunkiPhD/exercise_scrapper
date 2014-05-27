require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'mechanize'
require 'json'

puts 'script starting'
puts '--------------------------------------------'

module ExerciseDetails
	def self.gather_info(info, details)
		if details.length > 8
			return parse_long_info(info, details)
		else
			return parse_short_info(info, details)
		end
	end

	private

	def self.parse_short_info(info, details)
		# 0 = Type
		# 1 = Main Muscle
		# 2 = Equipment
		# 3 = Mechanics type
		# 4 = Competence level
		# 5 = is a sport
		# 6 = force type
		info[:type] = details[0]
		info[:main_muscle] = details[1]
		info[:equipment] = details[2]
		info[:mechanics] = details[3]
		info[:level] = details[4]
		info[:force] = details[6]
		info
	end


	def self.parse_long_info(info, details)
		# 0 = Type
		# 1 = Main Muscle
		# 2 through length - 7 = Other Muscles 
		# length - 7 = Equipment
		# length - 6 = Mechanics type
		# length - 5 = Mechanics
		# length - 4 = Competence level
		# length - 3 = is a sport
		# length - 2 = force type
		length = details.length
		info[:type] = details[0]
		info[:main_muscle] = details[1]
		info[:other_muscles] = details[2..length-7]
		info[:equipment] = details[length - 6]
		info[:mechanics] = details[length - 5]
		info[:level] = details[length - 4]
		info[:force] = details[length - 2]
		info
	end
end


class ExerciseScrapper
	attr_accessor :url

	def initialize(url)
		@url = url
		@agent = Mechanize.new
		@data = []
	end


	def scrape
		listings = @agent.get(@url)
		exercises_listings(listings)
		@data
	end


	private

	def exercises_listings(listings)
		listings.search('#pager a').each do |listing|
			exercises_for_letter(listing)
		end
	end


	def exercises_for_letter(listing)
		# each individual exercise by letter
		exercises_letter_list = @agent.click(listing)

		# this iterates over all the exercises on the page
		exercises_letter_list.search('h3 a').each do |exercise_listing|
			puts "#{exercise_listing.text.strip}"
			unless exercise_listing.text.include?("View All")
				exercise_page = @agent.click(exercise_listing)
				@data << exercise_info(exercise_page)
				#sleep_for_a_few
			end
		end
	end

	def sleep_for_a_few
		sleep_time = rand(1..5)
		sleep(sleep_time)
	end


	def exercise_info(exercise_page)
		info = { :name => "#{exercise_page.search('h1')[0].text.strip}", 
			:rating => exercise_page.search('#largeratingwidget .rating').text.to_f,
			:alternate_name => "#{exercise_page.search('h1+ p label').text.strip}"
		}
		details = exercise_page.search('#exerciseDetails p a').map(&:text)
		ExerciseDetails.gather_info(info, details)
		info[:directions] = exercise_page.search('.guideContent li').map { |x| x.text.squeeze.strip }
		info
	end
end

module WriteToJsonFile
	def self.write(arr, filename)
		File.open(filename, 'w') do |f|
			f.write(arr.to_json)
		end
	end
end


# we start off on the 0-9 listing page because there are only two exercises there (ones that no one cares about really) and the # in the links throws the parsing off
url = 'http://www.bodybuilding.com/exercises/list/index/selected/0-9'
scrapper = ExerciseScrapper.new(url)
@data = scrapper.scrape
puts @data
WriteToJsonFile.write(@data, "exercise_data.json")

puts '--------------------------------------------'
puts 'script ended!'
