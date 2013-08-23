class AddSoftDeleteToTeacherEvaluationTemplate < ActiveRecord::Migration
  def change
  	add_column :evaluation_templates, :deleted, :boolean, default: :false
  end
end
