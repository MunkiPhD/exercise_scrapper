require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'mechanize'

puts 'script starting'
puts '--------------------------------------------'
#url = 'http://www.bodybuilding.com/exercises/list/index/selected/a'
#doc = Nokogiri::HTML(open(url))
#file_path = '/home/munkiphd/development/exercise_scrapper/test_page.html'
#doc = Nokogiri::HTML(File.open(file_path))
#puts doc.at_css('title').text

class ExerciseParser
	def initialize(doc)
		@doc = doc
	end

	def pages
		puts @doc.search("#pager :nth-child(1)").map(&:text).join
	end

	def exercise_names
		@doc.search("h3 a").each do |node|
			puts node.text
		end
	end

	def self.exercise_info(exercise_page)
		info = {}
		info[:name] = exercise_page.search('h1')[0].text.strip
		details = exercise_page.search('#exerciseDetails a').map(&:text)
		if details.length > 8
			return parse_long_info(info, details)
		else
			return parse_short_info(info, details)
		end
	end

	private
	def self.parse_short_info(info, details)
		#	0 = Type
		# 1 = Main Muscle
		# 2 = Equipment
		# 3 = Mechanics type
		# 4 = Equipment
		# 5 = Competence level
		# 6 = is a sport
		# 7 = force type
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
		# 2 - length - 7 = Other Muscles 
		# length - 7 = Equipment
		# length - 6 = Mechanics type
		# length - 5 = Equipment
		# length - 4 = Competence level
		# length - 3 = is a sport
		# length - 2 = force type
		length = details.length
		info[:main_muscle] = details[1]
		info[:equipment] = details[length - 6]
		info[:mechanics] = details[length - 5]
		info[:level] = details[length - 4]
		info[:force] = details[length - 2]
		info
	end
end


# we start off with the 0-9 because there are only two exercises there, and the # in the links throws the parsing off
url = 'http://www.bodybuilding.com/exercises/list/index/selected/0-9'
agent = Mechanize.new
listings = agent.get(url)
listings.search('#pager a').each do |listing|
	# each individual exercise by letter
	exercises_letter_list = agent.click(listing)

	# this iterates over all the exercises on the page
	exercises_letter_list.search('h3 a').each do |exercise_listing|
		puts "looking at: #{exercise_listing.text.strip}"
		unless exercise_listing.text.include?("View All")
			exercise_page = agent.click(exercise_listing)
			info = ExerciseParser.exercise_info(exercise_page)
			puts info
			break
		end
	end
	break
end

puts '--------------------------------------------'
puts 'script ended!'
