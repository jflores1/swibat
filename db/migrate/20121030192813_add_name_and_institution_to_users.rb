class AddNameAndInstitutionToUsers < ActiveRecord::Migration
  def change
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :institution, :string
    remove_column :profiles, :first_name
    remove_column :profiles, :last_name
  end
end
