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
#  objective_type     :string(255)
#

require 'spec_helper'

describe Objective do
  context "A working model" do
    let(:objective){build_stubbed(:objective)}
    it {should respond_to(:objective)}
    it {should respond_to(:objective_type)}

    describe "an invalid objective type" do
      before{objective.objective_type = "Doodlebug"}
      it {expect {objective.save!}.to raise_error(ActiveRecord::RecordInvalid)}
    end

    describe "valid objectives" do
      before{objective.objective_type = "Content"}
      it {expect {objective.save!}.to_not raise_error(ActiveRecord::RecordInvalid)}
    end
  end

  context "Scopes" do
    describe "#content" do
      let(:objective) {create(:objective, objective_type: "Content")}
      it {Objective.content.should include(objective)}
    end

    describe "#skills" do
      let(:objective){create(:objective, objective_type: "Skill")}
      it {Objective.content.should_not include(objective)}
      it {Objective.skills.should include(objective)}
    end
  end

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
