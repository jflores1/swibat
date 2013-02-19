class CreateEvaluationCriteria < ActiveRecord::Migration
  def change
    create_table :evaluation_criteria do |t|
      t.string :contents
      t.integer :evaluation_domain_id

      t.timestamps
    end
  end
end
