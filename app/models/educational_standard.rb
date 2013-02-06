# == Schema Information
#
# Table name: educational_standards
#
#  id                 :integer          not null, primary key
#  name               :string(255)      not null
#  description        :text
#  url                :string(255)
#  standard_strand_id :integer
#  parent_id          :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

class EducationalStandard < ActiveRecord::Base
  attr_accessible :name, :description, :parent

  belongs_to :standard_strand
  belongs_to :parent, :foreign_key => "parent_id", :class_name => "EducationalStandard"
  has_many :children, :foreign_key => "parent_id", :class_name => "EducationalStandard"

  has_many :lesson_standards, dependent: :destroy
  has_many :lessons, through: :lesson_standards

  def self.covered_by_user(user)
  	covered_lesson_ids = user.lesson_ids
  	joins(lesson_standards: :lesson).where('lessons.id in (?)', covered_lesson_ids)
  	
  end
  
end
