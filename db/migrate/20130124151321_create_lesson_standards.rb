class CreateLessonStandards < ActiveRecord::Migration
  def change
    create_table :lesson_standards do |t|
    	t.belongs_to :educational_standard
    	t.belongs_to :lesson
      t.timestamps
    end
  end
end
