class CreateLeads < ActiveRecord::Migration
  def change
    create_table :leads do |t|
      t.string :name
      t.string :role
      t.string :school
      t.string :email
      t.string :phone

      t.timestamps
    end
  end
end
