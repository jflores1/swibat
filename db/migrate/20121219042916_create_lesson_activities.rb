class CreateLessonActivities < ActiveRecord::Migration
  def change
    create_table :lesson_activities do |t|
      t.string  :activity
      t.string  :duration
      t.string  :agent
      t.integer :lesson_id

      t.timestamps
    end
    add_index :lesson_activities, :lesson_id
  end
end
