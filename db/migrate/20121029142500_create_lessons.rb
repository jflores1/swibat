class CreateLessons < ActiveRecord::Migration
  def change
    create_table :lessons do |t|
      t.string :lesson_title
      t.date :lesson_start_date
      t.date :lesson_end_date
      t.string :lesson_status

      t.timestamps
    end
  end
end
