class AssociateEducationToUser < ActiveRecord::Migration
  def up
  	add_column :professional_educations, :user_id, :integer
  end

  def down
  	remove_column :professional_educations, :user_id
  end
end
