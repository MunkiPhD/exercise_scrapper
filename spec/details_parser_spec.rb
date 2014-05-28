require 'details_parser'
require 'mechanize'

describe DetailsParser do
	describe '.parse_details' do
		before(:each) do
			@agent = Mechanize.new
			@html_dir = File.dirname(__FILE__)
		end

		it 'returns correct data for Adductor/Groin exercise' do
			page = @agent.get("file:///#{@html_dir}/html_pages/adductor_groin_exercise.html")

			hash = DetailsParser.parse_details(page)
			expect(hash["Type"]).to eq "Stretching"
			expect(hash["Main Muscle Worked"]).to eq "Adductors"
			expect(hash["Equipment"]).to eq "None"
			expect(hash["Mechanics Type"]).to eq "N/A"
			expect(hash["Level"]).to eq "Intermediate"
			expect(hash["Sport"]).to eq "No"
			expect(hash["Force"]).to eq "Static"
		end


		it 'returns correct data for Barbell Full Squat exercise' do
			page = @agent.get("file:///#{@html_dir}/html_pages/barbell_full_squat_exercise.html")

			hash = DetailsParser.parse_details(page)
			expect(hash["Also Known As"]).to eq "Olympic Squat, High Bar Squat"
			expect(hash["Type"]).to eq "Strength"
			expect(hash["Main Muscle Worked"]).to eq "Quadriceps"
			expect(hash["Other Muscles"]).to eq "Calves, Glutes, Hamstrings, Lower Back"
			expect(hash["Equipment"]).to eq "Barbell"
			expect(hash["Mechanics Type"]).to eq "Compound"
			expect(hash["Level"]).to eq "Intermediate"
			expect(hash["Sport"]).to eq "Yes"
			expect(hash["Force"]).to eq "Push"
		end

		it 'returns correct data for Ab Crunch Machine exercise' do
			page = @agent.get("file:///#{@html_dir}/html_pages/ab_crunch_machine_exercise.html")

			hash = DetailsParser.parse_details(page)
			expect(hash["Type"]).to eq "Strength"
			expect(hash["Main Muscle Worked"]).to eq "Abdominals"
			expect(hash["Equipment"]).to eq "Machine"
			expect(hash["Mechanics Type"]).to eq "Isolation"
			expect(hash["Level"]).to eq "Intermediate"
			expect(hash["Sport"]).to eq "No"
			expect(hash["Force"]).to eq "Pull"
		end

		it 'returns correct data for Cable Tuck Reverse Crunch exercise' do
			page = @agent.get("file:///#{@html_dir}/html_pages/cable_tuck_reverse_crunch_exercise.html")

			hash = DetailsParser.parse_details(page)
			expect(hash["Type"]).to eq "Strength"
			expect(hash["Main Muscle Worked"]).to eq "Abdominals"
			expect(hash["Mechanics Type"]).to eq "Compound"
			expect(hash["Level"]).to eq "Beginner"
			expect(hash["Sport"]).to eq "No"
			expect(hash["Force"]).to eq "Pull"
		end

	end
end
