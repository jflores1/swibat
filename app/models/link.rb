# == Schema Information
#
# Table name: links
#
#  id         :integer          not null, primary key
#  link_type  :string(255)
#  url        :string(255)
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Link < ActiveRecord::Base
  attr_accessible :link_type, :url

  belongs_to :user

  validates :url, :presence => true
end
