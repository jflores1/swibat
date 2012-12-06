class CreateEducationalStandards < ActiveRecord::Migration
  def change
    create_table :educational_standards do |t|
    	t.string :name, :null => false
    	t.text :description
    	t.string :url
    	t.belongs_to :standard_strand
    	t.integer :parent_id
      t.timestamps
    end
  end
end
