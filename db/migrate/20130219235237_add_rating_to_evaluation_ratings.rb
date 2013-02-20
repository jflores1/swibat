class AddRatingToEvaluationRatings < ActiveRecord::Migration
  def change
  	add_column :evaluation_ratings, :score, :integer
  end
end
