class QueueItem < ActiveRecord::Base
	belongs_to :user
	belongs_to :video

	delegate :category, to: :video
	delegate :title, to: :video, prefix: :video

	validates_numericality_of :position, { only_integer: true }

	def rating
		review.rating if review
	end

	def category_name
		category.name
	end

	def rating=(new_rating)
		review = Review.find_by(user_id: user.id, video_id: video.id)

		if review
			review.update_column(:rating, new_rating)
		else
			review = Review.new(user: user, video: video, rating: new_rating)
			review.save(validate: false)
		end
	end

	private

	def review
		@review ||= Review.find_by(user_id: user.id, video_id: video.id)
	end

end