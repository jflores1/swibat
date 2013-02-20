require 'spec_helper'

describe EvaluationCriterion do
  describe "Attributes" do
  	it {should respond_to(:evaluation_domain)}
  	it {should respond_to(:contents)}
  end
end
