class AddAttachmentToResource < ActiveRecord::Migration
  def change
  	add_attachment :resources, :upload
  end
end
