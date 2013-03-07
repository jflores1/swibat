class RenameActivityModel < ActiveRecord::Migration
  def up
  	rename_table :activities, :lesson_activities
  end

  def down
  	rename_table :lesson_activities, :activities
  end
end
