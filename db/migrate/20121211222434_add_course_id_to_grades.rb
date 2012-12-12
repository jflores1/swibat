class AddCourseIdToGrades < ActiveRecord::Migration
  def change
    add_column :grades, :course_id, :integer
  end
end
