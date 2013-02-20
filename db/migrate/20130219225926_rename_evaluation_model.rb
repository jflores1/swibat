class RenameEvaluationModel < ActiveRecord::Migration
  def up
  	rename_table :evaluations, :teacher_evaluations
  end

  def down
  	rename_table :teacher_evaluations, :evaluations
  end
end
