class CreateEvaluationRatings < ActiveRecord::Migration
  def change
    create_table :evaluation_ratings do |t|
      t.integer :evaluation_id
      t.integer :criterion_id

      t.timestamps
    end
  end
end
