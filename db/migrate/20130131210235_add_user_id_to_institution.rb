class AddUserIdToInstitution < ActiveRecord::Migration
  def change
  	add_column :institutions, :user_id, :integer
  	remove_column :users, :institution
  end
end
