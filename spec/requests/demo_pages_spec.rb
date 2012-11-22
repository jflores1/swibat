require 'spec_helper'

describe "DemoPages" do
  subject { page }

  context "Working Routes" do
    describe "Admin Panel path" do
      it "gets the admin_panel demo path" do
        get "demo/admin_panel"
        response.status.should be(200)
      end
    end

    describe "Classroom Observations Path" do
      it "gets the classroom observations path" do
        get "demo/classroom_observations"
        response.status.should be(200)
      end
    end

    describe "Course Plan route" do
      it "gets the course_plan route" do
        get "demo/course_plan"
        response.status.should be(200)
      end
    end

    describe "Lesson Plan route" do
      it "gets the lesson plan route" do
        get "demo/lesson_plan"
        response.status.should be(200)
      end
    end

    describe "Parent Feedback route" do
      it "gets the lesson plan route" do
        get "demo/parent_feedback"
        response.status.should be(200)
      end
    end

    describe "Peer Feedback route" do
      it "gets the Peer Feedback route" do
        get "demo/peer_feedback"
        response.status.should be(200)
      end
    end
  end
end
