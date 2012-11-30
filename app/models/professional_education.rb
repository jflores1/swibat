# == Schema Information
#
# Table name: professional_educations
#
#  id               :integer          not null, primary key
#  school_name      :string(255)
#  degree           :string(255)
#  field_of_study   :string(255)
#  enroll_date      :string(255)
#  graduation_date  :string(255)
#  additional_notes :text
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class ProfessionalEducation < ActiveRecord::Base
  attr_accessible :additional_notes, :degree, :enroll_date, :field_of_study, :graduation_date, :school_name

  belongs_to :user

  validates :school_name, :presence => true
end
