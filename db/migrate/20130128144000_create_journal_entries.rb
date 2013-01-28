class CreateJournalEntries < ActiveRecord::Migration
  def change
    create_table :journal_entries do |t|
      t.float :average_score
      t.float :median_score
      t.float :highest_score
      t.float :lowest_score
      t.text :lesson_pros
      t.text :lesson_cons
      t.belongs_to :lesson
      t.timestamps
    end
  end
end
