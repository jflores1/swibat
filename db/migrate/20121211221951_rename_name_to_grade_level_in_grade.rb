class RenameNameToGradeLevelInGrade < ActiveRecord::Migration
  def up
    rename_column :grades, :name, :grade_level
  end

  def down
    rename_column :grades, :grade_level, :name
  end
end
