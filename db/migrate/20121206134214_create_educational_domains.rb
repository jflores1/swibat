class CreateEducationalDomains < ActiveRecord::Migration
  def change
    create_table :educational_domains do |t|
      t.string :name
      t.integer :parent_id
      t.timestamps
    end
  end
end
