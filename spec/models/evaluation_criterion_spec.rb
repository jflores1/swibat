# == Schema Information
#
# Table name: evaluation_criteria
#
#  id                   :integer          not null, primary key
#  contents             :string(255)
#  evaluation_domain_id :integer
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  deleted              :boolean          default(FALSE)
#

require 'spec_helper'

describe EvaluationCriterion do
  describe "Attributes" do
  	it {should respond_to(:evaluation_domain)}
  	it {should respond_to(:contents)}
  end
end
