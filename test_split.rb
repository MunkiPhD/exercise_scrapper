
def sanitize(page)
	page.search("#exerciseDetails p br").map {|n| n.replace("++")}
	data = page.search("#exerciseDetails p").map { |n| n.text }
	data = data.map { |n| n.split("++") }
	data.flatten!
	data = data.map { |n| n.squeeze(" ").strip }
	data = data.map { |n| n.split(":") }
	data.inject ({}) do |r,s|
		r.merge!( { s[0].strip => s[1].strip })
	end
end
