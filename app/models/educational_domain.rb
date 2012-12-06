# == Schema Information
#
# Table name: educational_domains
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  parent_id  :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class EducationalDomain < ActiveRecord::Base
  attr_accessible :name, :parent

  has_many :standard_strands, :dependent => :destroy
  belongs_to :parent, :foreign_key => "parent_id", :class_name => "EducationalDomain"
  has_many :children, :foreign_key => "parent_id", :class_name => "EducationalDomain"

  has_many :domain_grades, :dependent => :destroy
  has_many :grades, :through => :domain_grades
end
