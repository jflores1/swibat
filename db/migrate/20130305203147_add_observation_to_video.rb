class AddObservationToVideo < ActiveRecord::Migration
  def change
  	add_column :videos, :observation_id, :integer
  end
end
