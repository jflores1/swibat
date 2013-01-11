# == Schema Information
#
# Table name: resources
#
#  id                  :integer          not null, primary key
#  name                :string(255)
#  description         :text
#  lesson_id           :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  upload_file_name    :string(255)
#  upload_content_type :string(255)
#  upload_file_size    :integer
#  upload_updated_at   :datetime
#

class Resource < ActiveRecord::Base

	has_attached_file :upload,                     
                    :storage => :s3, :s3_credentials => "#{Rails.root}/config/amazon_s3.yml",
                    :path => "resources/:id-:basename.:extension"                    

  belongs_to :lesson

  attr_accessible :description, :name, :upload, :lesson_id

  validates :name, :presence => true
  validates :description, :length => {:maximum => 1000}
  validates_attachment_size :upload, :in => 0.megabytes..15.megabytes
  #validates_attachment_presence :upload

  # Duplication rules
  amoeba do 
  	exclude_field [:upload_file_name, :upload_content_type, :upload_file_size, :upload_updated_at]

  	# copy the attachment file
  	override(lambda { |original_resource, new_resource|
      new_resource.upload = original_resource.upload
    })

  end

end
