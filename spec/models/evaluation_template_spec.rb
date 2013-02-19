require 'spec_helper'

describe EvaluationTemplate do
  describe "Attributes" do
  	it {should respond_to(:institution)}
  	it {should respond_to(:evaluation_domains)}
  	it {should respond_to(:evaluations)}
  	it {should respond_to(:published)}
  end
end
