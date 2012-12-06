# == Schema Information
#
# Table name: grades
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Grade < ActiveRecord::Base
  attr_accessible :name
  has_many :domain_grades, :dependent => :destroy
  has_many :educational_domains, :through => :domain_grades

  validates :name, :presence => true
  validates :name, :uniqueness => true
end
