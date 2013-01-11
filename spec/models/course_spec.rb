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

  describe "Duplicating" do
    let(:course){ Course.create(course_name:"Physics", course_semester:"Spring", course_year:"2013", course_summary:"It is a summary.", grade_id: "1") }

    before do
      @user = FactoryGirl.create(:user)
      @tom = FactoryGirl.create(:user, first_name: "Tom", last_name: "Hanks")
      course.user = @user      
      course.save
      unit = FactoryGirl.create(:unit, course: course)
      unit.save
      comment = Comment.build_from(course, @tom.id, "my comment")
      comment.save
      course.objectives.create(objective: "first objective")
      course.objectives.create(objective: "second objective")      
      course.tag_list = "tag 1, tag 2"
      f = Flag.build_from(course, @user.id)
      f.save      
      course.add_or_update_evaluation(:votes, 1, @user)
      
      @new_course = course.duplicate_for @tom
    end

    it "should duplicate the object" do
      Course.count.should be(2)
    end

    it "should assign the object to the current_user" do      
      Course.count.should be(2)
      Course.last.user_id.should be(@tom.id)
    end

    it "should duplicate the objectives" do
      Objective.count.should be(4)
    end

    it "should copy the tags" do
      @new_course.tag_list.count.should be(2)
    end

    it "should exclude the flags" do 
      @new_course.flags.count.should be(0)
    end

    it "should reset the ratings" do
      @new_course.reputation_for(:votes).should eq(0.0)
      @new_course.has_evaluation?(:votes, @user).should be_false
    end

    it "should not copy the comments" do
      @new_course.comment_threads.count.should be(0)
    end

    it "should duplicate the units" do 
      Unit.count.should be(2)
      Unit.last.course_id.should be(@new_course.id)
    end
    
  end

end
