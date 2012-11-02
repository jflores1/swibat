# == Schema Information
#
# Table name: courses
#
#  id              :integer          not null, primary key
#  course_name     :string(255)
#  course_semester :string(255)
#  course_year     :integer
#  course_summary  :text
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  user_id         :integer
#

require 'spec_helper'

describe Course do
  let(:course){Course.new(course_name:"Physics", course_semester:"Spring", course_year:"2013", course_summary:"It is a summary.")}
  subject {course}

  it {should respond_to(:course_name)}
  it {should respond_to(:course_semester)}
  it {should respond_to(:course_year)}
  it {should respond_to(:course_summary)}
  describe "without a course name" do
    before {course.course_name = " "}
    it {should_not be_valid}
    it {expect {course.save!}.to raise_error(ActiveRecord::RecordInvalid)}
  end

  describe "without a semester" do
    before {course.course_semester = " "}
    it {should_not be_valid}
    it {expect {course.save!}.to raise_error(ActiveRecord::RecordInvalid)}
  end

  describe "without a course_year" do
    before {course.course_year = " "}
    it {should_not be_valid}
    it {expect {course.save!}.to raise_error(ActiveRecord::RecordInvalid)}
  end

  describe "with a course semester out of season" do
    before {course.course_semester = "Something"}
    it {should_not be_valid}
    it {expect {course.save!}.to raise_error(ActiveRecord::RecordInvalid)}
  end

  describe "with a valid semester" do
    before {course.course_semester = "Fall"}
    it {should be_valid}
    it {expect {course.save!}.to change{Course.count}.by(1)}
  end

  describe "with a non-4-digit year" do
    before {course.course_year = 19992}
    it {should_not be_valid}
    it {expect {course.save!}.to raise_error(ActiveRecord::RecordInvalid)}
  end

  describe "with a 4-digit year" do
    before {course.course_year = 2012}
    it {should be_valid}
    it {expect {course.save!}.to change{Course.count}.by(1)}
  end

  describe "Can create associated objects" do
    let(:course){FactoryGirl.create(:course)}

    describe "can have at least one objective" do
      before {@objective = course.objectives.build(objective:"Test velocity of sparrow's wings.")}
      it {expect {course.save!}.to change{Objective.count}.by(1)}
    end

    describe "Can have multiple objectives" do
      before {@objective = course.objectives.create(objective:"Test velocity of sparrow's wings.")}
      before {@objective = course.objectives.create(objective:"Test velocity of sparrow's wings.")}
      it {course.objectives.count.should == 2}
    end

    describe "Can have at least one associated assessment" do
      before {@assessment = course.assessments.build(assessment_name:"Test their knowledge")}
      it {expect {course.save!}.to change{Assessment.count}.by(1)}
    end

    describe "Can have multiple assessments" do
      before {@assessment = course.assessments.create(assessment_name:"Test their knowledge.")}
      before {@assessment = course.assessments.create(assessment_name:"Using a project.")}
      it {course.assessments.count.should == 2}
    end

  end

end
