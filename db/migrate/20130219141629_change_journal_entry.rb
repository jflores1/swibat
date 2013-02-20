class ChangeJournalEntry < ActiveRecord::Migration
  def up
  	rename_column :journal_entries, :lesson_pros, :pros
  	rename_column :journal_entries, :lesson_cons, :cons
  	remove_column :journal_entries, :average_score
  	remove_column :journal_entries, :median_score
  	remove_column :journal_entries, :highest_score
  	remove_column :journal_entries, :lowest_score

  end

  def down
  	rename_column :journal_entries, :pros, :lesson_pros
  	rename_column :journal_entries, :cons, :lesson_cons
  	add_column :journal_entries, :average_score, :float
  	add_column :journal_entries, :median_score, :flaot
  	add_column :journal_entries, :highest_score, :float
  	add_column :journal_entries, :lowest_score, :float
  end
end
