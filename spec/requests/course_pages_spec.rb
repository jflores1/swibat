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

  context "A Working Form" do
    before {sign_in_via_form}
    let(:submit){"Create Course"}

    #describe "There is a form on the page" do
    #  it {response.body.should have_selector("form")}
    #end

    describe "With valid information" do
      # let(:user){FactoryGirl.create(:user)}
      
      before do
        #login_as(user, scope = :user)        
        visit new_user_course_path(@user)
        fill_out_course_form_with_valid_info        
      end

      it "should add a new course for the user" do
        @user.courses.count.should == 0
        click_button submit
        @user.courses.count.should == 1
      end
      # Warden.test_reset!
    end

    describe "With invalid information" do
      pending

    end
  end

  private
  def sign_in_user_and_go_to_page
    sign_in_as_a_valid_user
    get new_user_course_path(@user)
  end

  def fill_out_course_form_with_valid_info
    fill_in 'course_name',      with: "Physics 1"
    select  'Fall',             :from => 'course_course_semester'    
    fill_in 'course_year',      with: "2012"
    fill_in 'course_name',      with: "This is a valid course summary."
  end

  def fill_out_course_form_with_invalid_info

  end

end
