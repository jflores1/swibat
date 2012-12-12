class AddCourseIdToGradeLevel < ActiveRecord::Migration
  def change
    add_column :grade_levels, :course_id, :integer
  end
end
