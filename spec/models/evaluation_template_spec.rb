# == Schema Information
#
# Table name: evaluation_templates
#
#  id             :integer          not null, primary key
#  institution_id :integer
#  published      :boolean
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  name           :string(255)
#

require 'spec_helper'

describe EvaluationTemplate do
  describe "Attributes" do
  	it {should respond_to(:institution)}
  	it {should respond_to(:evaluation_domains)}
  	it {should respond_to(:evaluations)}
  	it {should respond_to(:published)}
  	it {should respond_to(:evaluations)}
  end
end
