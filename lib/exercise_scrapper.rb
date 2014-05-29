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
			end
		end
	end


	def exercise_info(exercise_page)
		info = { :name => "#{exercise_page.search('h1')[0].text.strip}", :rating => exercise_page.search('#largeratingwidget .rating').text.to_f	}
		#details = exercise_page.search('#exerciseDetails p a').map(&:text)
		info.merge!(DetailsParser.parse_details(exercise_page))
		info[:directions] = exercise_page.search('.guideContent li').map { |x| x.text.squeeze(" ").strip }
		puts info
		return verified_data(info)
	end


	def verified_data(data)
		data[:name] ||= ""
		data[:rating] ||= 0
		data[:type] ||= "N/A"
		data[:main_muscle_worked] ||= "N/A"
		data[:other_muscles] ||= ""
		data[:equipment] ||= "None"
		data[:mechanics_type] ||= "N/A"
		data[:level] ||= "Beginner"
		data[:sport] ||= "No"
		data[:force] ||= "N/A"
		data[:directions] ||= []
		data
	end
end

