require 'spec_helper'

describe "LessonPages" do
  let(:unit){FactoryGirl.create(:unit)}

  context "When a user is signed in" do
    describe "It allows access" do
      before do
        sign_in_as_a_valid_user
        get new_unit_lesson_path(unit)
      end
      it {response.status.should be(200)}
    end

    describe "Add a lesson" do
      let(:submit){"Submit"}
      let(:add_another_lesson){"Add Another Lesson"}
      let(:lesson){unit.lessons}

      context "With valid information" do
        before {
          sign_in_and_go_to_page
        }
        it "should add a lesson and then another" do
          expect {
            fill_in_form_with_valid_information
            click_button add_another_lesson
          }.to change(lesson, :count).by(1)
          current_path.should == new_unit_lesson_path(unit)
        end

        it "should add a lesson and go back to user page" do
          expect {
            fill_in_form_with_valid_information
            click_button submit
          }.to change(lesson, :count).by(1)
          current_path.should == user_path(@user)
        end
      end

      context "With invalid information" do
        before {sign_in_and_go_to_page}
        it "should not add a lesson" do
          expect {
            fill_in_form_with_invalid_information
            click_button submit
          }.to_not change(lesson, :count).by(1)
        end
        it {current_path.should == new_unit_lesson_path(unit)}
      end
    end

  end

  context "A user not signed in" do
    it "cannot access the page" do
      get new_unit_lesson_path(unit)
      response.status.should be(302)
    end
  end

  private
  def sign_in_and_go_to_page
    sign_in_via_form
    visit new_unit_lesson_path(unit)
  end

  def fill_in_form_with_valid_information
    fill_in "lesson_title",       with: "A new Lesson"
    fill_in "lesson_start_date",  with: "2013/01/01"
    fill_in "lesson_end_date",    with: "2013/01/10"
    fill_in "lesson_status",      with: "Pending"
    fill_in "prior_knowledge",    with: "None required"
  end

  def fill_in_form_with_invalid_information
    fill_in "lesson_title",       with: "A new Lesson"
    fill_in "lesson_start_date",  with: "2013/01/01"
    fill_in "lesson_end_date",    with: "2013/01/10"
    fill_in "lesson_status",      with: "Invalid Status"
    fill_in "prior_knowledge",    with: "None required"
  end

end

