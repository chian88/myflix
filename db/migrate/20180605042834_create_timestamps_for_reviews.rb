class CreateTimestampsForReviews < ActiveRecord::Migration
  def change
    create_table :timestamps_for_reviews do |t|
    	add_column :reviews, :created_at, :datetime
    	add_column :reviews, :updated_at, :datetime
    end
  end
end
