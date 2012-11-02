class CreateProfessionalExperiences < ActiveRecord::Migration
  def change
    create_table :professional_experiences do |t|
      t.string :title
      t.string :location
      t.text :description
      t.boolean :still_work, default: false
      t.string :work_start_month
      t.integer :work_start_year
      t.string :work_end_month
      t.integer :work_end_year

      t.timestamps
    end
  end
end
