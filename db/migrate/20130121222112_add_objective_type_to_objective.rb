class AddObjectiveTypeToObjective < ActiveRecord::Migration
  def change
    add_column :objectives, :objective_type, :string, default: "Goal"
  end
end
