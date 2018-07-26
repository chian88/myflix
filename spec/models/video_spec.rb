require 'spec_helper'

describe Video do
	it { should belong_to(:category) }
	it { should validate_presence_of(:title) }
	it { should validate_presence_of(:description) }
	it { should have_many(:reviews).order('created_at DESC') }
	

	describe "search_by_title" do
		it 'return an empty array if there is no match' do
			futurama = Video.create(title: 'Futurama', description: 'space travel')
			back_to_future = Video.create(title: 'Back to Future', description: 'time travel')
			expect(Video.search_by_title("hello")).to eq([])
		end

		it 'return an array of one video for an exact match' do
			futurama = Video.create(title: 'Futurama', description: 'space travel')
			back_to_future = Video.create(title: 'Back to Future', description: 'time travel')
			expect(Video.search_by_title("Futurama")).to eq([futurama])
		end

		it 'return an array of one video for a partial match' do
			futurama = Video.create(title: 'Futurama', description: 'space travel')
			back_to_future = Video.create(title: 'Back to Future', description: 'time travel')
			expect(Video.search_by_title("urama")).to eq([futurama])
		end

		it 'return an array of all matches ordered by created_at' do
			futurama = Video.create(title: 'Futurama', description: 'space travel', created_at: 1.day.ago)
			back_to_future = Video.create(title: 'Back to Future', description: 'time travel')
			expect(Video.search_by_title('Futur')).to eq([back_to_future, futurama])
		end

		it 'return an empty array for a search with an empty string' do
			futurama = Video.create(title: 'Futurama', description: 'space travel')
			back_to_future = Video.create(title: 'Back to Future', description: 'time travel')
			expect(Video.search_by_title("")).to eq([])
		end

	end
end