# == Schema Information
#
# Table name: units
#
#  id                  :integer          not null, primary key
#  unit_title          :string(255)
#  expected_start_date :date
#  expected_end_date   :date
#  prior_knowledge     :string(255)
#  unit_status         :string(255)
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  course_id           :integer
#

require 'spec_helper'

describe Unit do
  let(:unit){Unit.new(unit_title:"Evaluate the morality of the Industrial Revolution", expected_start_date:"8/15/2012", expected_end_date:"8/20/2012", prior_knowledge:"None", unit_status:"Started")}
  subject {unit}

  it {should respond_to(:unit_title)}
  it {should respond_to(:expected_start_date)}
  it {should respond_to(:expected_end_date)}
  it {should respond_to(:prior_knowledge)}
  it {should respond_to(:unit_status)}
  it {should respond_to(:comment_threads)}

  context "With invalid information" do
    describe "without a unit title" do
      before {unit.unit_title = " "}
      it {should_not be_valid}
    end

    describe "without an expected start date" do
      before {unit.expected_start_date = " "}
      it {should_not be_valid}
    end

    describe "without an expected end date" do
      before {unit.expected_end_date}
      it {should_not be_valid}
    end

    describe "without a unit status" do
      before {unit.unit_status = ""}
      it {should_not be_valid}
    end

    describe "with an invalid unit status" do
      before {unit.unit_status = "Invalid unit status"}
      it {should_not be_valid}
    end

    describe "if end date is greater than start date" do
      before {unit.expected_end_date = 12/12/2012, unit.expected_start_date = 12/15/2012}
      it {should_not be_valid}
    end

  end

  context "with valid information" do
    let(:unit){FactoryGirl.create(:unit)}
    describe "with a valid unit status" do
      before {unit.unit_status = "Complete"}
      it {should be_valid}
    end
  end

  context "With valid associations" do
    let(:unit){FactoryGirl.create(:unit)}

    describe "can have at least one objective" do
      before {@objective = unit.objectives.build(objective:"Test velocity of sparrow's wings.")}
      it {expect {unit.save!}.to change{Objective.count}.by(1)}
    end

    describe "Can have multiple objectives" do
      before {@objective = unit.objectives.create(objective:"Test velocity of sparrow's wings.")}
      before {@objective = unit.objectives.create(objective:"Test velocity of sparrow's wings.")}
      it {unit.objectives.count.should == 2}
    end

    describe "Can have at least one associated assessment" do
      before {@assessment = unit.assessments.build(assessment_name:"Test their knowledge")}
      it {expect {unit.save!}.to change{Assessment.count}.by(1)}
    end

    describe "Can have multiple assessments" do
      before {@assessment = unit.assessments.create(assessment_name:"Test their knowledge.")}
      before {@assessment = unit.assessments.create(assessment_name:"Using a project.")}
      it {unit.assessments.count.should == 2}
    end

  end

end
