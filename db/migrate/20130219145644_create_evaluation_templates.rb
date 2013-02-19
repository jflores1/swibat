class CreateEvaluationTemplates < ActiveRecord::Migration
  def change
    create_table :evaluation_templates do |t|
      t.integer :institution_id
      t.boolean :published
      t.timestamps
    end
  end
end
