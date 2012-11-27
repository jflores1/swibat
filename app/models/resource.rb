class Resource < ActiveRecord::Base

	has_attached_file :upload,                     
                    :storage => :s3, :s3_credentials => "#{Rails.root}/config/amazon_s3.yml",
                    :path => "resources/:id-:basename.:extension"                    

  belongs_to :lesson

  attr_accessible :description, :name, :upload

  validates :name, :presence => true
  validates :description, :length => {:maximum => 1000}
  validates_attachment_size :upload, :in => 0.megabytes..15.megabytes
  validates_attachment_presence :upload

end
