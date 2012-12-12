class CreateGradeLevels < ActiveRecord::Migration
  def change
    create_table :grade_levels do |t|
      t.string :grade_level

      t.timestamps
    end
  end
end
