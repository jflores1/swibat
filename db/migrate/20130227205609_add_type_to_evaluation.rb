class AddTypeToEvaluation < ActiveRecord::Migration
  def change
		add_column :teacher_evaluations, :eval_type, :string
  end
end
