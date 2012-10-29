class AddCourseIdToLessons < ActiveRecord::Migration
  def change
    add_column :lessons, :unit_id, :integer
    add_index :lessons, :unit_id
  end
end
