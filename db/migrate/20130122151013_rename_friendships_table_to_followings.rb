class RenameFriendshipsTableToFollowings < ActiveRecord::Migration
  def up
  	rename_table :friendships, :followings
  	remove_column :followings, :status
  	rename_column :followings, :friend_id, :followee_id
  end

  def down
  	rename_table :followings, :friendships
  	add_column :friendships, :status, :null => false, :default => "pending"      
  	rename_column :friendships, :followee_id, :friend_id
  end
end
