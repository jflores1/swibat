# == Schema Information
#
# Table name: evaluation_domains
#
#  id                     :integer          not null, primary key
#  name                   :string(255)
#  evaluation_template_id :integer
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  deleted                :boolean          default(FALSE)
#

require 'spec_helper'

describe EvaluationDomain do
  describe "Attributes" do
  	it {should respond_to(:evaluation_template)}
  	it {should respond_to(:evaluation_criteria)}
  	it {should respond_to(:name)}
  end
end
