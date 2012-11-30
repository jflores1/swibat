class RenameColumnNames < ActiveRecord::Migration
  def up
  	rename_column :links, :type, :link_type
  	rename_column :professional_accomplishments, :type, :accomplishment_type
  end

  def down
  	rename_column :links, :link_type, :type
  	rename_column :professional_accomplishments, :accomplishment_type, :type
  end
end
