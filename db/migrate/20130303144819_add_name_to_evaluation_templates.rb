class AddNameToEvaluationTemplates < ActiveRecord::Migration
  def change
  	add_column :evaluation_templates, :name, :string
  end
end
