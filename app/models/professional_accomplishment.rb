# == Schema Information
#
# Table name: professional_accomplishments
#
#  id                  :integer          not null, primary key
#  accomplishment_type :string(255)
#  name                :string(255)
#  year                :integer
#  user_id             :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

class ProfessionalAccomplishment < ActiveRecord::Base
  attr_accessible :name, :accomplishment_type, :year

  belongs_to :user

  validates :name, :presence => true
end
