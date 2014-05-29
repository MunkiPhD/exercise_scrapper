module DetailsParser
	def self.parametize(str)
		str.gsub(/\s+/, "_").downcase
	end

	def self.parse_details(page)
		page.search("#exerciseDetails p br").map {|n| n.replace("++")}
		data = page.search("#exerciseDetails p").map { |n| n.text }
		data.map! { |n| n.split("++") }.flatten!
		data.map! { |n| n.squeeze(" ").strip.split(":") }
		data.reject! { |n| n.empty? }
		data = data.inject ({}) do |r,s|
			r.merge!( { parametize(s[0].strip).to_sym => s[1].strip })
		end
		data.delete :your_rating
		data
	end
end
