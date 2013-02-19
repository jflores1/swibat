require 'spec_helper'

describe EvaluationDomain do
  describe "Attributes" do
  	it {should respond_to(:evaluation_template)}
  	it {should respond_to(:evaluation_criteria)}
  	it {should respond_to(:name)}
  end
end
