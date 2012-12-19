class CreateActivities < ActiveRecord::Migration
  def change
    create_table :activities do |t|
      t.string  :activity
      t.string  :duration
      t.string  :agent
      t.integer :lesson_id

      t.timestamps
    end
    add_index :activities, :lesson_id
  end
end
