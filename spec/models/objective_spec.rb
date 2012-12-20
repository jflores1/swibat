# == Schema Information
#
# Table name: objectives
#
#  id                 :integer          not null, primary key
#  objective          :string(255)
#  objectiveable_id   :integer
#  objectiveable_type :string(255)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

require 'spec_helper'

describe Objective do
  
  describe "find_similar_objectiveables" do
  	before do 
  		@unit = FactoryGirl.create(:unit)
  		@lesson1 = FactoryGirl.create(:lesson, :unit => @unit)
  		@lesson2 = FactoryGirl.create(:lesson, :unit => @unit)
  		@lesson3 = FactoryGirl.create(:lesson, :unit => @unit)
  		@lesson1.objectives.create(:objective => "Heat measurement using different temperature tools")
  		@lesson1.objectives.create(:objective => "The laws of thermodynamics")

  		@lesson2.objectives.create(:objective => "Solve first degree equations in one variable")
  		@lesson2.objectives.create(:objective => "Solve literal equations and formulas for a single variable.")
  		@lesson2.objectives.create(:objective => "Solve quadratic equations by factoring.")

  		@lesson3.objectives.create(:objective => "Basic structure of the Constitution.")
  		@lesson3.objectives.create(:objective => "Roles and functions of the three branches of government.")

  		@candidate_objectives = ["Laws of thermodynamics and measuring temperature", "Three different measuring tools."]
  	end

  	it "returns the proper objectiveable" do
  		results = Objective.find_similar_objectiveables(@candidate_objectives, "Lesson", "objectives")
  		results.count.should == 1
  		results.first[:objectiveable].should == @lesson1
  	end

	end
end
