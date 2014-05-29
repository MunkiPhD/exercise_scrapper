require 'details_parser'
require 'mechanize'

describe DetailsParser do
	describe '.parametize' do
		it 'creates a parametized string' do
			expect(DetailsParser.parametize("Main Muscle Worked")).to eq "main_muscle_worked"
		end

		it 'returns the correct result for a single word' do
			expect(DetailsParser.parametize("Force")).to eq "force"
		end
	end

	describe '.parse_details' do
		before(:each) do
			@agent = Mechanize.new
			@html_dir = File.dirname(__FILE__)
		end

		it 'returns correct data for Adductor/Groin exercise' do
			page = @agent.get("file:///#{@html_dir}/html_pages/adductor_groin_exercise.html")

			hash = DetailsParser.parse_details(page)
			expect(hash[:type]).to eq "Stretching"
			expect(hash[:main_muscle_worked]).to eq "Adductors"
			expect(hash[:equipment]).to eq "None"
			expect(hash[:mechanics_type]).to eq "N/A"
			expect(hash[:level]).to eq "Intermediate"
			expect(hash[:sport]).to eq "No"
			expect(hash[:force]).to eq "Static"
		end


		it 'returns correct data for Barbell Full Squat exercise' do
			page = @agent.get("file:///#{@html_dir}/html_pages/barbell_full_squat_exercise.html")

			hash = DetailsParser.parse_details(page)
			expect(hash[:also_known_as]).to eq "Olympic Squat, High Bar Squat"
			expect(hash[:type]).to eq "Strength"
			expect(hash[:main_muscle_worked]).to eq "Quadriceps"
			expect(hash[:other_muscles]).to eq "Calves, Glutes, Hamstrings, Lower Back"
			expect(hash[:equipment]).to eq "Barbell"
			expect(hash[:mechanics_type]).to eq "Compound"
			expect(hash[:level]).to eq "Intermediate"
			expect(hash[:sport]).to eq "Yes"
			expect(hash[:force]).to eq "Push"
		end

		it 'returns correct data for Ab Crunch Machine exercise' do
			page = @agent.get("file:///#{@html_dir}/html_pages/ab_crunch_machine_exercise.html")

			hash = DetailsParser.parse_details(page)
			expect(hash[:type]).to eq "Strength"
			expect(hash[:main_muscle_worked]).to eq "Abdominals"
			expect(hash[:equipment]).to eq "Machine"
			expect(hash[:mechanics_type]).to eq "Isolation"
			expect(hash[:level]).to eq "Intermediate"
			expect(hash[:sport]).to eq "No"
			expect(hash[:force]).to eq "Pull"
		end

		it 'returns correct data for Cable Tuck Reverse Crunch exercise' do
			page = @agent.get("file:///#{@html_dir}/html_pages/cable_tuck_reverse_crunch_exercise.html")

			hash = DetailsParser.parse_details(page)
			expect(hash[:type]).to eq "Strength"
			expect(hash[:main_muscle_worked]).to eq "Abdominals"
			expect(hash[:mechanics_type]).to eq "Compound"
			expect(hash[:level]).to eq "Beginner"
			expect(hash[:sport]).to eq "No"
			expect(hash[:force]).to eq "Pull"
		end
	end
end
