class CreateProfessionalEducations < ActiveRecord::Migration
  def change
    create_table :professional_educations do |t|
      t.string :school_name
      t.string :degree
      t.string :field_of_study
      t.string :enroll_date
      t.string :graduation_date
      t.text :additional_notes

      t.timestamps
    end
  end
end
