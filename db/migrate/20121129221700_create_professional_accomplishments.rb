class CreateProfessionalAccomplishments < ActiveRecord::Migration
  def change
    create_table :professional_accomplishments do |t|
      t.string :type
      t.string :name
      t.integer :year
      t.belongs_to :user
      t.timestamps
    end
  end
end
