require 'spec_helper'

describe "UserPages" do
  subject { page }

  describe "Application Header" do
    let(:user){create(:user)}

    context "when not signed in" do
      before {visit user_path(user)}
      it {page.should have_selector("a", text: "sign up" )}
    end

    context "when signed in" do
      before do
        sign_in_via_form
      end

      describe "and user has no courses" do
        it {page.should have_selector("a", text: "add course")}
      end

      describe "and user has a course" do
        let!(:course){create(:course, user: @user)}
        before do
          visit user_path(@user)
        end
        it {page.should have_selector("a", text: "my courses")}
      end
    end

  end

  describe "User profile page" do
    context "The user isn't signed in" do
      let(:user){create(:user)}
      before {visit user_path(user)}

      it {page.should have_content(user.full_name)}
      it {page.should have_selector("img[alt='Jesse Flores']")}
      it {page.should have_selector("a", text: "Follow")}
      it "clicking follow redirects to sign in page" do
        click_link("Follow")
        current_path.should eq(new_user_registration_path)
      end

      context "a user with courses" do
        let!(:course){create(:course, user: user)}
        before {visit user_path(user)}
        it {page.should have_content("Physics")}
      end

      context "a user belonging to a school" do
        let(:user_with_school){create(:user_with_profile)}
        before {visit user_path(user_with_school)}
        it {page.should have_content("School")}
      end

      context "a user with a profile" do
        let(:user_with_profile){create(:user_with_profile)}
        before {visit user_path(user_with_profile)}
        it {page.should have_content("My College")}
        it {page.should have_content("Award")}
        it {page.should have_content("@twitter")}
      end
    end
    context "The user is signed in" do
      describe "and viewing his own profile page" do
        before do
          sign_in_via_form
          visit user_path(@user)
        end

        it {page.should have_selector("a", text: "Add Some Personality!")}
        it "clicking 'Add Some Personality' goes to the the edit path" do
          click_link("Add Some Personality!")
          current_path.should eq(edit_user_path(@user))
        end
        it {page.should have_selector("a#user-add-course")}
        it "clicking 'user-add-course' navigates to new course path" do
          click_link("user-add-course")
          current_path.should eq(new_course_path)
        end

        describe "can navigate to an existing course" do
          let!(:course){create(:course, user: @user)}
          before {visit user_path(@user)}
          it {page.should have_selector("a.edit-user-course")}
          it "should go to the edit course page" do
            find("a.edit-user-course").click
            current_path.should eq(course_path(course))
          end

        end
      end
      describe "and viewing another users profile page" do
        describe "follow/unfollow buttons" do
          let(:other_user){create(:user)}
          before do
            sign_in_via_form
          end

          describe "following a user" do
            before {visit user_path(other_user)}
            it "should increment the user's people_followed count" do
              expect{
                click_button("Follow")
              }.to change(@user.people_followed, :count).by(1)
            end
            it "should increment the other user's follower count" do
              expect{
                click_button("Follow")
              }.to change(other_user.followers, :count).by(1)
            end
            describe "toggling the button", js: true do
              before {click_button "Follow"}
              it {page.should have_selector('input', value: 'Unfollow')}
            end
          end

          describe "unfollowing a user" do
            before do
              @user.follow!(other_user)
              visit user_path(other_user)
            end

            it "should decrement the followed user count" do
              expect{click_button "Unfollow"}.to change(@user.people_followed, :count).by(-1)
            end
            it "should decrement the number of followers" do
              expect {click_button "Unfollow"}.to change(other_user.followers, :count).by(-1)
            end
          end
        end

      end
    end
  end

  describe "User Edit Page" do
    let(:user){create(:user)}
    context "an unregistered user" do
      before {visit edit_user_path(user)}
      it "should deny access" do
        current_path.should eq(user_session_path)
      end
    end

    context "a registered user" do
      before do
        sign_in_via_form
        visit edit_user_path(user)
      end
      it {page.should have_content("Sorry, you don't have access to this page!")}
      it {current_path.should eq(user_path(@user))}
    end

    context "the owning user" do
      before do
        sign_in_via_form
        visit edit_user_path(@user)
      end

      it {current_path.should eq(edit_user_path(@user))}
      describe "can update user information" do
        it "allows user to update first name" do
          fill_in "first_name", with: "Bob"
          click_button("Save Changes")
          page.should have_content("Bob")
        end
        it "allows the user to update last name" do
          fill_in "last_name", with: "Smith"
          click_button("Save Changes")
          page.should have_content("Smith")
        end

        describe "it allows the user to write a bio" do
          it "allows the user to add a short blurb" do
            fill_in "profile_summary", with: "A short blurb"
            click_button("Save Changes")
            page.should have_content("A short blurb")
          end

          it "does not allow a long blurb" do
            fill_in "profile_summary", with: ("a"*180)
            click_button("Save Changes")
            page.should have_content("Sorry")
          end
        end

        describe "it allows the user to edit Institution" do
          it "allows the user to add an institution" do
            expect {
              fill_in "institution", with: "A new school"
              click_button("Save Changes")
            }.to change(Institution, :count).by(1)
            page.should have_content("A new school")
          end
        end
      end

    end

  end

  describe "The User Index Page" do
    before(:all) do
      25.times do
        create(:user)
      end
    end
    before(:each) do
      visit users_path
    end

    it {page.should have_content("All Users")}

    describe "the search feature" do
      xit "it allows search by name"
      xit "it allows search by school"
    end

    describe "it allows users to invite other users" do

    end
  end


  context "With relevant profile information displayed" do
    before do 
      sign_in_via_form           
    end
    
    it "only shows attributes that the user has filled out" do
      @user.professional_educations.create(:school_name => "my old school", :degree => "MSc.", :field_of_study => "Computer science", :enroll_date => "2011-01-01", :graduation_date => "2012-01-01"  )
      @user.specialties.create(:name => "Ruby on Rails")
      @user.specialties.create(:name => "Javascript")
      @user.links.create(:link_type => "Twitter Profile", :url => "http://twitter.com/marjan")
      @user.professional_accomplishments.create(:accomplishment_type => "Award", :name => "Best programmer", :year => "2007")
      @user.professional_accomplishments.create(:accomplishment_type => "Certificate", :name => "Ruby On Rails Instructor", :year => "2010")
      @user.profile_summary = "this is my profile summary"
      @user.save
      visit user_path(@user) 

      page.should have_content("Education:")      
      page.should have_content("Certifications:")      
      page.should have_content("Awards:")      
      page.should have_content("Twitter:")

      page.should have_content("my old school")      
      page.should have_content("MSc.")      
      page.should have_content("Computer science")      
      page.should have_content("2011-01-01")      
      page.should have_content("2012-01-01")
      page.should have_content("Ruby on Rails")
      page.should have_content("Javascript")
      page.should have_content("http://twitter.com/marjan")
      page.should have_content("Best programmer")
      page.should have_content("Ruby On Rails Instructor")
      page.should have_content("2007")
      page.should have_content("2010")
      page.should have_content("this is my profile summary")
    end

    it "it does not show attributes teh user has not filled out" do
      visit user_path(@user) 
      page.should_not have_content("Specialties:")      
      page.should_not have_content("Education:")      
      page.should_not have_content("Certifications:")      
      page.should_not have_content("Awards:")      
      page.should_not have_content("Connect:")      
    end
  end



  private
  def can_update_form_field(form_field, form_text)
    fill_in form_field, with: form_text
    click_button save
    expect(page).to have_content(form_text)
  end

  def can_update_select_field(form_option, from_field)
    select form_option, from: from_field
    click_button save
    expect(page).to have_content(form_option)
  end


end
