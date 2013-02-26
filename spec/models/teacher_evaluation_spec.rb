# == Schema Information
#
# Table name: teacher_evaluations
#
#  id                     :integer          not null, primary key
#  teacher_id             :integer
#  evaluation_template_id :integer
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#

require 'spec_helper'

describe TeacherEvaluation do
  it {should respond_to(:evaluation_template)}
	it {should respond_to(:teacher)}
end
