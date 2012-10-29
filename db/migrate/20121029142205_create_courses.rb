class CreateCourses < ActiveRecord::Migration
  def change
    create_table :courses do |t|
      t.string :course_name
      t.string :course_semester
      t.integer :course_year
      t.text :course_summary

      t.timestamps
    end
  end
end
