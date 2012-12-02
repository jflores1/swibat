# == Schema Information
#
# Table name: specialties
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Specialty < ActiveRecord::Base
  attr_accessible :name

  belongs_to :user

  validates :name, :presence => true
end
