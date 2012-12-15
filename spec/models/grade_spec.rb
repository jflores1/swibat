# == Schema Information
#
# Table name: grades
#
#  id          :integer          not null, primary key
#  grade_level :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  course_id   :integer
#

require 'spec_helper'

describe Grade do
  it {should respond_to(:grade_level)}
end
