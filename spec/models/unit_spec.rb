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
  it {should respond_to(:flags)}
  it {should respond_to(:reputation_for)}

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


  describe "Duplicating" do    
    let(:course){ Course.create(course_name:"Physics", course_semester:"Spring", course_year:"2013", course_summary:"It is a summary.", grade_id: "1") }

    before do
      @user = FactoryGirl.create(:user)
      @tom = FactoryGirl.create(:user, first_name: "Tom", last_name: "Hanks")
      course.user = @user      
      course.save

      @unit = FactoryGirl.create(:unit, course: course)
      @unit.save

      comment = Comment.build_from(@unit, @tom.id, "my comment")
      comment.save

      @unit.objectives.create(objective: "first objective")
      @unit.objectives.create(objective: "second objective")      
      @unit.assessments.create(assessment_name: "first assessment")
      @unit.assessments.create(assessment_name: "second assessment")

      FactoryGirl.create(:lesson, unit_id: @unit.id)

      f = Flag.build_from(@unit, @user.id)
      f.save      

      @unit.add_or_update_evaluation(:votes, 1, @user)
      
      @new_course = course.duplicate_for @tom
      @new_unit = Unit.last
    end

    it "should duplicate the object" do
      Unit.count.should be(2)
    end

    it "should assign the object to the proper course" do      
      @new_unit.course_id.should be(@new_course.id)      
    end

    it "should duplicate the objectives" do
      Objective.count.should be(4)
      @new_unit.objectives.count.should be(2)
    end

    it "should duplicate the assessments" do
      Assessment.count.should be(4)
      @new_unit.assessments.count.should be(2)
    end

    it "should exclude the flags" do 
      @new_unit.flags.count.should be(0)
    end

    it "should reset the ratings" do
      @new_unit.reputation_for(:votes).should eq(0.0)
      @new_unit.has_evaluation?(:votes, @user).should be_false
    end

    it "should not copy the comments" do
      @new_unit.comment_threads.count.should be(0)
    end

    it "should duplicate the lessons" do 
      Lesson.count.should be(2)
      Lesson.last.unit_id.should be(@new_unit.id)
    end
    
  end

end
