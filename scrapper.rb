require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'mechanize'

puts 'hello!'
#url = 'http://www.bodybuilding.com/exercises/list/index/selected/a'
#doc = Nokogiri::HTML(open(url))
file_path = '/home/munkiphd/development/exercise_scrapper/test_page.html'
doc = Nokogiri::HTML(File.open(file_path))
puts doc.at_css('title').text

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
		info[:main_muscle] = details[1]
		info[:mechanics] = details[3]
		info[:level] = details[4]
		info[:sport] = details[5]
		info[:force] = details[6]
		info
	end
end

#parser = ExerciseParser.new(doc)
#parser.pages

# we start off with the 0-9 because there are only two exercises there, and the # in the links throws the parsing off
url = 'http://www.bodybuilding.com/exercises/list/index/selected/0-9'
agent = Mechanize.new
listings = agent.get(url)
listings.search('#pager a').each do |listing|
	# each individual exercise by letter
	exercises_letter_list = agent.click(listing)
	exercises_letter_list.search('h3 a').each do |exercise_listing|
		puts "looking at: #{exercise_listing.text}"
		unless exercise_listing.text.include?("View All")
			exercise_page = agent.click(exercise_listing)

			info = ExerciseParser.exercise_info(exercise_page)
			puts info
			#exercise_name = exercise_page.search('h1')[0].text.strip
			#puts "Exercise: '#{exercise_name}'"

			#results = exercise_page.search('#exerciseDetails a').map(&:text)

			#puts results
			break
		end
	end
	break
end

puts 'the end'
