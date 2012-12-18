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
#  grade_id        :integer
#

require 'spec_helper'

describe Course do
  let(:course){Course.new(course_name:"Physics", course_semester:"Spring", course_year:"2013", course_summary:"It is a summary.", grade_id: "1")}
  subject {course}

  describe "Attributes & associations" do
    it {should respond_to(:course_name)}
    it {should respond_to(:course_semester)}
    it {should respond_to(:course_year)}
    it {should respond_to(:course_summary)}
    it {should respond_to(:comment_threads)}
    it {should respond_to(:grade_id)}
    it {should respond_to(:flags)}
    it {should respond_to(:reputation_for)}
  end

  context "With proper validation" do
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

    describe "without a grade id" do
      before {course.grade_id = ""}
      it {should_not be_valid}
      it {expect {course.save!}.to raise_error(ActiveRecord::RecordInvalid)}
    end

  end

  context "With valid associations" do
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

    describe "Can have an associated grade level" do
      before{@grade_level = course.create_grade(grade_level: "Grade 12")}
      it {course.grade.should_not be_nil}
    end

  end

end
