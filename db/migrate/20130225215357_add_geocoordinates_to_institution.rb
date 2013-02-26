class AddGeocoordinatesToInstitution < ActiveRecord::Migration
  def change
  	add_column :institutions, :longitude, :float
  	add_column :institutions, :latitude, :float
  end
end
