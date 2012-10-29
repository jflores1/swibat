class CreateAssessments < ActiveRecord::Migration
  def change
    create_table :assessments do |t|
      t.string :assessment_name
      t.belongs_to :assessable, polymorphic: true

      t.timestamps
    end
    add_index :assessments, [:assessable_id, :assessable_type]
  end
end
