class CreateEvaluationDomains < ActiveRecord::Migration
  def change
    create_table :evaluation_domains do |t|
      t.string :name
      t.integer :evaluation_template_id

      t.timestamps
    end
  end
end
