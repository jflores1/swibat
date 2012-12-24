# == Schema Information
#
# Table name: lessons
#
#  id                :integer          not null, primary key
#  lesson_title      :string(255)
#  lesson_start_date :date
#  lesson_end_date   :date
#  lesson_status     :string(255)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  unit_id           :integer
#  prior_knowledge   :string(255)
#

require 'spec_helper'

describe Lesson do
  let(:lesson){Lesson.new(lesson_title:"Describe the ending of the 3 little pigs", lesson_start_date: 12/12/2012, lesson_end_date: 12/15/2012, lesson_status:"Active", prior_knowledge: "none")}
  subject { lesson }

  it {should respond_to(:lesson_title)}
  it {should respond_to(:lesson_start_date)}
  it {should respond_to(:lesson_end_date)}
  it {should respond_to(:lesson_status)}
  it {should respond_to(:prior_knowledge)}
  it {should respond_to(:comment_threads)}
  it {should respond_to(:flags)}

  context "With Invalid information" do
    describe "Without a lesson title" do
      before {lesson.lesson_title = " "}
      it {should_not be_valid}
    end

    describe "Without a lesson start date" do
      before {lesson.lesson_start_date = " "}
      it {should_not be_valid}
    end

    describe "Without a lesson end date" do
      before {lesson.lesson_end_date}
      it {should_not be_valid}
    end

    describe "With an end date less than a start date" do
      before {lesson.lesson_start_date = 12/10/2012, lesson.lesson_end_date = 12/01/2012}
      it {should_not be_valid}
    end

    describe "Without a lesson status" do
      before {lesson.lesson_status = " "}
      it {should_not be_valid}
    end

    describe "With an invalid lesson status" do
      before {lesson.lesson_status = "Saved"}
      it {should_not be_valid}
    end
  end

  context "With valid information" do
    let(:lesson){FactoryGirl.create(:lesson)}
    describe "With valid lesson status" do
      before {lesson.lesson_status = "Not Yet Started"}
      it {should be_valid}
    end
  end

end
