class CreateResources < ActiveRecord::Migration
  def change
    create_table :resources do |t|
      t.string :name
      t.text :description
      t.belongs_to :lesson
      t.timestamps
    end
  end
end
