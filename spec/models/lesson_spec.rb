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

  describe "Duplicating" do    
    let(:course){ Course.create(course_name:"Physics", course_semester:"Spring", course_year:"2013", course_summary:"It is a summary.", grade_id: "1") }

    before do
      @user = FactoryGirl.create(:user)
      @tom = FactoryGirl.create(:user, first_name: "Tom", last_name: "Hanks")
      course.user = @user      
      course.save

      unit = FactoryGirl.create(:unit, course: course)
      lesson = FactoryGirl.create(:lesson, unit: unit)
      
      comment = Comment.build_from(lesson, @tom.id, "my comment")
      comment.save

      lesson.objectives.create(objective: "first objective")
      lesson.objectives.create(objective: "second objective")      

      lesson.assessments.create(assessment_name: "first assessment")
      lesson.assessments.create(assessment_name: "second assessment")

      FactoryGirl.create(:activity, lesson_id: lesson.id)
      
      resource = Resource.new(lesson_id: lesson.id, name: "MyString", description: "MyText", upload: File.new(Rails.root + 'spec/fixtures/files/upload.txt'))
      resource.save

      f = Flag.build_from(lesson, @user.id)
      f.save      

      lesson.add_or_update_evaluation(:votes, 1, @user)
      
      @new_course = course.duplicate_for @tom
      @new_unit = Unit.last
      @new_lesson = Lesson.last
    end

    it "should duplicate the object" do
      Lesson.count.should be(2)
    end

    it "should assign the object to the proper unit" do      
      @new_lesson.unit_id.should be(@new_unit.id)      
    end

    it "should duplicate the assessments" do
      Assessment.count.should be(4)
      @new_lesson.assessments.count.should be(2)
    end

    it "should duplicate the objectives" do
      Objective.count.should be(4)
      @new_lesson.objectives.count.should be(2)
    end

    it "should duplicate the activities" do 
      Activity.count.should be(2)
      Activity.last.lesson_id.should be(@new_lesson.id)
    end

    it "should exclude the flags" do 
      @new_lesson.flags.count.should be(0)
    end

    it "should reset the ratings" do
      @new_lesson.reputation_for(:votes).should eq(0.0)
      @new_lesson.has_evaluation?(:votes, @user).should be_false
    end

    it "should not copy the comments" do
      @new_lesson.comment_threads.count.should be(0)
    end

    it "should duplicate the resources and the files" do
      Resource.count.should be(2)
      @new_lesson.resources.count.should be(1)      
      first_file = Resource.first.upload
      second_file = Resource.last.upload
      first_file.url.should_not equal second_file.url
    end   
    
  end

end
