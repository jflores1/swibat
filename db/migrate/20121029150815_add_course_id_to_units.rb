class AddCourseIdToUnits < ActiveRecord::Migration
  def change
    add_column :units, :course_id, :integer
    add_index :units, :course_id
  end
end
