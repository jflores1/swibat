class CreateUnits < ActiveRecord::Migration
  def change
    create_table :units do |t|
      t.string :unit_title
      t.date :expected_start_date
      t.date :expected_end_date
      t.string :prior_knowledge
      t.string :unit_status

      t.timestamps
    end
  end
end
