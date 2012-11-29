require 'spec_helper'

describe "UnitPages" do
  let(:course){FactoryGirl.create(:course)}

  context "When a user is signed in" do
    describe "it allows access" do
      before do
        sign_in_as_a_valid_user
        get new_course_unit_path(course)
      end
      it {response.status.should be(200)}
    end

    describe "Add a unit" do
      let(:submit){"Save and Come Back Later"}
      let(:move_on){"Add Some Lessons"}
      let(:unit){course.units}


      context "with valid information" do
        before {sign_in_and_go_to_form}
        it "saves and returns to user profile page" do
          expect {
            fill_out_form_with_valid_information
            click_button submit
          }.to change(unit, :count).by(1)
        end

        it "saves and goes to the lesson page" do
          expect {
            fill_out_form_with_valid_information
            click_button move_on
          }.to change(unit, :count).by(1)
          current_path.should == new_unit_lesson_path(1)
        end

        it "has at least one objective" do
          expect {
            fill_out_form_with_valid_information
            click_button submit
          }.to change(unit, :count).by(1)
          Unit.last.objectives.count.should == 1
        end

        it "has at least one assessment" do
          expect {
            fill_out_form_with_valid_information
            click_button submit
          }.to change(unit, :count).by(1)
          Unit.last.assessments.count.should == 1
        end
      end

      context "With invalid information" do
        before {sign_in_and_go_to_form}
        it "does not create a unit" do
          expect {
            fill_out_form_with_invalid_information
            click_button submit
          }.to_not change(unit, :count).by(1)
        end
        it {current_path.should == new_course_unit_path(course)}
      end
    end

  end

  context "When a user is not signed in" do
    describe "it does not allow access" do
      before {get new_course_unit_path(course)}
      it {response.status.should be(302)}
    end
  end

  private
  def sign_in_and_go_to_form
    sign_in_via_form
    visit new_course_unit_path(course)
  end

  def fill_out_form_with_valid_information
    fill_in "unit_title",           with: "A New Unit"
    fill_in "expected_start_date",  with: "2013/01/01"
    fill_in "expected_end_date",    with: "2013/01/10"
    fill_in "prior_knowledge",      with: ""
    fill_in "unit_status",          with: "Pending"
    fill_in 'unit_objectives_attributes_0_objective',               with: "An objective"
    fill_in 'unit_assessments_attributes_0_assessment_name',        with: "An assessment"
  end

  def fill_out_form_with_invalid_information
    fill_in "unit_title",           with: "A New Unit"
    fill_in "expected_start_date",  with: "2013/01/01"
    fill_in "expected_end_date",    with: "2013/01/10"
    fill_in "prior_knowledge",      with: ""
    fill_in "unit_status",          with: "Invalid Status"
  end

end
