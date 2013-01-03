require 'spec_helper'

describe CoursePresenter do
  include ActionView::TestCase::Behavior

  context "When information not provided" do
    let!(:presenter){CoursePresenter.new(Course.new, view)}

    it "doesn't have a course name" do
      presenter.course_name.should include("None provided yet")
    end
    it "doesn't have a grade" do
      presenter.grade_level.should include("None provided yet")
    end
    it "doesn't say when the course is being taught" do
      presenter.taught_during.should include("None provided yet")
    end

  end

  context "When information is provided" do
    let(:course){create(:course)}
    let(:unit){course.units.create(:unit)}
    let!(:presenter){CoursePresenter.new(course, view)}

    it "has a course name" do
      presenter.course_name.should include(course.course_name)
    end

    it "has a grade level" do
      presenter.grade_level.should include(course.grade.grade_level)
    end

    it "has a course summary" do
      presenter.course_summary.should include(course.course_summary)
    end

    it "has course objectives" do
      @objective = course.objectives.create(objective:"objective")
      presenter.course_objectives.first.objective.should include("objective")
    end

    describe "it shows unit content" do

      it "shows the unit title" do
        presenter.unit_titles.should include("industrial revolution")
      end
    end
  end




end