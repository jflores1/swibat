class AddProfileSummaryToUser < ActiveRecord::Migration
  def change
  	add_column :users, :profile_summary, :text
  end
end
