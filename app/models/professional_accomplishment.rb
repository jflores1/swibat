class ProfessionalAccomplishment < ActiveRecord::Base
  attr_accessible :name, :accomplishment_type, :year

  belongs_to :user

  validates :name, :presence => true
end
