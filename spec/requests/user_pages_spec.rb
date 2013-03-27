require 'spec_helper'

describe "UserPages" do
  subject { page }

  describe "Application Header" do
    let(:user){create(:user)}

    context "when not signed in" do
      before {visit user_path(user)}
      it "does not allow access to a user page" do
        current_path.should eq(new_user_session_path)
      end

      before {visit user_path(user)}
      it {page.should have_selector("a", text: "sign up" )}
      it {page.should have_selector("a", text: "Explore")}
      it "navigates to the /users path" do
        click_link("Explore")
        click_link("Users")
        current_path.should eq(users_path)
      end
      it "navigates to the /courses path" do
        click_link("Explore")
        click_link("Courses")
        current_path.should eq(courses_path)
      end

      it "does not navigate to the /users/:id/maps path" do
        page.should_not have_selector("a", text: "maps")
      end
    end

    context "when signed in" do
      before do
        sign_in_via_form
      end

      describe "and user has no courses" do
        it {page.should have_selector("a", text: "Add a Course")}
      end

      describe "and user has a course" do
        let!(:course){create(:course, user: @user)}
        before do
          visit user_path(@user)
        end
        it {page.should have_selector("a", text: "my courses")}
        it {page.should have_selector("a", text: "maps")}
      end
    end

  end

  describe "User profile page" do
    context "The user isn't signed in" do
      let(:user){create(:user)}
      before {visit user_path(user)}
      it {current_path.should eq(new_user_session_path)}
      it {page.should_not have_content("Courses")}
    end

    describe "The user is signed in" do
      context "The user is a teacher" do
        before do
          sign_in_via_form
          visit user_path(@user)
        end

        describe "The teacher sidebar" do
          subject {page}
          it {should have_selector("a", text: "Dashboard")}
          it {should have_selector("a", text: "Videos")}
          it {should have_selector("a", text: "Observations")}
          it {should have_selector("a", text: "Professional Goals")}
          it {should have_selector("a", text: "Jesse")}
        end

        describe "Working Links" do
          it "navigate to the user dashboard" do
            find_link("Dashboard").click
            current_path.should eq(user_path(@user))
          end
          
          it "navigate to the videos page" do
            find_link("Videos").click
            current_path.should eq(videos_user_path(@user))
          end

          xit "navigate to the observations page" do
            find_link("Observations").click
            current_path.should eq(evaluations_user_path(@user))
          end

          xit "navigate to the professional goals page" do
            find_link("Professional Goals").click
            current_path.should eq(professional_goals_user_path(@user))
          end

          it "navgiate to edit the user's profile page" do
            find_link("Jesse").click
            current_path.should eq(edit_user_path(@user))
          end
        end

        describe "The dashboard" do
          it {page.should have_selector("h1", text: "Dashboard")}

          describe "observation content" do
            context "The user has no observations" do
              it {page.should have_selector("span", text: "0")}
              it {page.should have_selector("p", text: "Observations")}
            end

            context "The user has at least one observation" do
              
            end
          end

          describe "video content" do
            context "The user has no videos" do
              it {page.should have_selector("span", text: "0")}
              it {page.should have_selector("p", text: "Videos")}
            end

            context "The user has videos" do
              
            end
          end

          describe "Active Goals" do
            context "The user has no active goals" do
              it {page.should have_selector("span", text: "0")}
              it {page.should have_selector("p", text: "Active Goals")}
            end
          end

          describe "Cannot see other users' information" do
            it {page.should_not have_selector("h3", text: "Faculty")}
          end
          
        end
      end

      context "The user is a school administrator" do
        before do
          sign_in_as_admin
          visit user_path(@user)
        end
        
        describe "the admin sidebar" do
          subject {page}
          it {should have_selector("a", text: "Dashboard")}
          it {should have_selector("a", text: "Faculty")}
          it {should have_selector("a", text: "Templates")}
          it {should have_selector("a", text: "School Info")}
          it {should have_selector("a", text: "Jesse")}
        end

        describe "working sidebar links" do
          it "navigates to the faculty page" do
            find_link("Faculty").click
            current_path.should eq(faculty_institution_path(@user.institution))
          end
          it "navigates to the templates page" do
            find_link("Templates").click
            current_path.should eq(institution_evaluation_templates_path(@user.institution))
          end
          it "navigates to the school info page" do
            find_link("School Info").click
            current_path.should eq(edit_institution_path(@user.institution))
          end
        end

        describe "the admin dashboard" do
          it {page.should have_selector("h3", text: "Faculty")}
        end

        describe "visiting a teacher's profile page" do
          let(:teacher){create(:user, role: "teacher", first_name: "Teacher", institution_id: @user.institution_id)}
          before do
            visit user_path(teacher)
          end
          subject {page}
          it {print page.html}
          it {should have_selector("a", text: "Teacher")}
          it {should have_selector("a", text: "Videos")}
          it {should have_selector("a", text: "Observations")}

          describe "Working links to teacher specific information" do
            it "navigates to teacher dashboard" do
              find_link("Teacher").click
              current_path.should eq(user_path(teacher))
            end
            it "navigates to the teacher's observations" do
              find_link("Observations").click
              current_path.should eq(evaluations_user_path(teacher))
            end
            it "navigates to the teacher's videos" do
              find_link("Videos").click
              current_path.should eq(videos_user_path(teacher))
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
              fill_in "user_institution_attributes_name", with: "A new school"
              click_button("Save Changes")
            }.to change(Institution, :count).by(1)
            page.should have_content("A new school")
          end
        end
      end

    end

  end

  describe "Signing up a User" do
    before {visit new_user_registration_path}
    it "adds a new user" do
      expect{
        fill_in "user_full_name", with: "Jesse Flores"
        fill_in "user_email", with: "new_user@email.com"
        fill_in "user_password", with: "password"
        fill_in "user_password_confirmation", with: "password"    
        click_button "Sign Up!"
      }.to change(User, :count).by(1)  
    end
    
  end

  describe "The User Index Page" do

    before(:each) do
      visit users_path
    end

    it {page.should have_content("All Users")}
    it {page.should have_selector("form")}

    describe "it displays all users" do
      let!(:users){create_list(:user, 10)}
      before do
        @last_user = User.last
        visit users_path
      end
      it {page.should have_selector("div", id: "user_#{@last_user.id}")}
    end

    describe "the user search form" do
      let!(:search_user){create(:user, first_name: "Fred", last_name:"Astaire")}
      before do
        visit users_path
      end
      it "returns the user" do
        fill_in "q", with: "Fred"
        click_button "Search"
        page.should have_content("Fred Astaire")
        page.should_not have_content("Jesse Flores")
      end
    end

    describe "it allows users to invite other users" do

    end
  end

  describe "The User Map Page" do
    before do
      sign_in_via_form
    end
    let!(:course){create(:course, user: @user)}

    #TODO: Unclear why this test fails; it works in the browser. Is it the current_user variable?
    it "navigates to the content map page" do
      click_link("maps")
      click_link("My Courses")
      page.should have_content("Content Map")
    end

    describe "it shows the standards covered by user lessons" do
      let!(:course){create(:course, user: @user)}
      let!(:unit){create(:unit_with_lessons, course: course)}

      before {visit content_map_user_path(@user)}

      it "lists all standards for the grades taught by the teacher" do
        #
      end
    end

  end

  describe "The User Video Page" do
    let(:admin){create(:user_with_profile, role:"school_admin")}
    let(:faculty_member){create(:user_with_profile, first_name:"Bob", role:"teacher")}
    context "The Teacher" do
      before do
        5.times do
          create(:video)
        end
        sign_in_via_form
        visit videos_user_path(@user)
      end
      it {page.should have_content("#{@user.full_name}'s Videos")}
      
    end

    context "The Administrator" do
      
    end
  end

  describe "The Followed User Map Page" do
    let!(:other_user){create(:user)}
    let!(:other_course){create(:course, user: other_user)}
    before do
      sign_in_via_form
      @user.follow!(other_user)
    end
    it "is navigable from the application header" do
      click_link("maps")
      click_link("Courses I Follow")
      page.should have_content("Mapped Objectives")
      current_path.should eq(followed_maps_user_path(@user))
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
