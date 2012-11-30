class Link < ActiveRecord::Base
  attr_accessible :link_type, :url

  belongs_to :user

  validates :url, :presence => true
end
