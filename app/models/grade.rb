# == Schema Information
#
# Table name: grades
#
#  id          :integer          not null, primary key
#  grade_level :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Grade < ActiveRecord::Base
  attr_accessible :grade_level, :courses_attributes, :educational_domains_attributes
  has_many :domain_grades, :dependent => :destroy
  has_many :educational_domains, :through => :domain_grades
  has_many :courses

  accepts_nested_attributes_for :courses

  validates :grade_level, :presence => true
  validates :grade_level, :uniqueness => true
end
