class CreateObjectives < ActiveRecord::Migration
  def change
    create_table :objectives do |t|
      t.string :objective
      t.belongs_to :objectiveable, polymorphic: true

      t.timestamps
    end
    add_index :objectives, [:objectiveable_id, :objectiveable_type]
  end
end
