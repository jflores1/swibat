require 'spec_helper'
include Warden::Test::Helpers
Warden.test_mode!

describe "CoursePages" do

  context "Accessing the User Course Page" do
    describe "An authorized user tries to get access" do
      it "should allow access" do
        sign_in_user_and_go_to_page
        response.status.should be(200)
      end

    end

    describe "An unauthorized user tries to get access" do
      it "should not allow access" do
        get new_course_path
        response.status.should be(302)
      end
    end
  end

  describe "A Working Form" do
    before do
      sign_in_via_form
      visit new_user_course_path(@user)
    end
    let(:unit_button){"Create a Unit"}
    let(:save_button){"Save and Return"}
    let(:course){@user.courses}

    describe "There is a form on the page" do
      it {page.should have_selector("form")}
    end

    context "With valid information" do
      it "Allows a user to save a course and go back to their account page" do
        expect {
          fill_out_course_form_with_valid_info
          click_button save_button
        }.to change(course, :count).by(1)
        current_path.should == user_path(@user)
      end
      it "Allows a user to save a course and go the Unit page" do
        expect {
          fill_out_course_form_with_valid_info
          click_button unit_button
        }.to change(course, :count).by(1)
        current_path.should == new_course_unit_path(1)
      end
    end

    context "With invalid information" do
      it "Does not add a save an invalid course for the user" do
        expect {
          fill_out_course_form_with_invalid_info
          click_button save_button
        }.to_not change(course, :count).by(1)
        invalid_form_expectations
      end

      it "Does not allow a user to go to a unit page with an invalid course" do
        expect {
          fill_out_course_form_with_invalid_info
          click_button unit_button
        }.to_not change(course, :count).by(1)
        invalid_form_expectations
      end
    end
  end

  private
  def sign_in_user_and_go_to_page
    sign_in_as_a_valid_user
    get new_user_course_path(@user)
  end

  def fill_out_course_form_with_valid_info
    fill_in 'course_name',     with: "Physics 1"
    select  'Fall',            from: "course_course_semester"
    fill_in 'course_year',     with: "2012"
    fill_in 'course_summary',  with: "This is a valid course summary."
  end

  def fill_out_course_form_with_invalid_info
    fill_in 'course_name',     with: "Physics 1"
    select  'Fall',            from: "course_course_semester"
    fill_in 'course_year',     with: "20122"
    fill_in 'course_summary',  with: "This is a valid course summary."
  end

  def invalid_form_expectations
    page.should have_content("Sorry")
    page.should have_selector("form")
  end

end
