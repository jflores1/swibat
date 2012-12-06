class CreateStandardStrands < ActiveRecord::Migration
  def change
    create_table :standard_strands do |t|
    	t.string :name, :null => false
    	t.belongs_to :educational_domain    	
      t.timestamps
    end
  end
end
