class AddSoftDeleteToTeacherEvaluation < ActiveRecord::Migration
  def change
  	add_column :evaluation_domains, :deleted, :boolean, default: :false
  	add_column :evaluation_criteria, :deleted, :boolean, default: :false
  end
end
