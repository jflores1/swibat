class DropTableGradeLevel < ActiveRecord::Migration
  def up
    drop_table  :grade_levels
  end

  def down
    create_table :grade_levels, :grade_level, :string, :course_id, :integer
  end
end
