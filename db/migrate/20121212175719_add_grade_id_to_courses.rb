class AddGradeIdToCourses < ActiveRecord::Migration
  def change
    add_column :courses, :grade_id, :integer
    remove_column :grades, :course_id
  end
end
