class CreateEvaluations < ActiveRecord::Migration
  def change
    create_table :evaluations do |t|
      t.integer :teacher_id
      t.integer :evaluation_template_id

      t.timestamps
    end
  end
end
