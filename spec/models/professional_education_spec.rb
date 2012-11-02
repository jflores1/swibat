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

require 'spec_helper'

describe ProfessionalEducation do
  pending "add some examples to (or delete) #{__FILE__}"
end
