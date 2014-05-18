require 'rubygems'
require 'nokogiri'
require 'open-uri'

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
		puts @doc.css("#pager :nth-child(1)").map(&:text).join
	end

	def exercise_names
		@doc.css("h3 a").each do |node|
			puts node.text
		end
	end
end

parser = ExerciseParser.new(doc)
parser.pages
