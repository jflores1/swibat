class AddUploaderToVideos < ActiveRecord::Migration
  def change
  	add_column :videos, :uploader_id, :integer
  end
end
