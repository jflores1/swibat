class AddInstitutionIdToUser < ActiveRecord::Migration
  def change
  	remove_column :institutions, :user_id
  	add_column :users, :institution_id, :integer
  end
end
