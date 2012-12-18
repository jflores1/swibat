require 'spec_helper'

describe "UserPages" do
  subject { page }

  context "When signed in" do
    before do
      sign_in_via_form
    end

    describe "Accesses Profile Page" do
      before {visit user_path(@user)}
      it {page.should have_content(@user.full_name)}
      it {page.should have_selector("img[alt='Jesse Flores']")}
      it {page.should have_css('i.icon-plus')}
    end

    describe "Can see All Users" do
      before {visit users_path}
      it {page.should have_content "All Users"}
    end

    context "Current user profile page" do
      let!(:course){create(:course)}
      before {visit user_path(@user)}

      describe "Can add a new course" do
        before {find('#user-add-course').click}
        it {page.current_path.should eq(new_course_path)}
      end

      describe "Can navigate to course show page" do
        it "should navigate to edit_user_course_page" do
          find('.edit-user-course').click
          current_path.should == course_path(course)
        end
      end

      describe "without any questions asked" do
        it {page.should have_selector("p", text:"It doesn't look like you've asked any questions.")}
        it {page.should have_selector("h3", text: "0 Questions")}
        it "directs the user to add a question" do
          find_link("Have one?").click
          current_path.should == new_question_path
        end
      end

      describe "with questions" do
        let!(:question){create(:question)}
        before {visit user_path(@user)}
        it {page.should have_selector("li", text: "Question title")}
        it {page.should have_selector("h3", text: "1 Question")}
      end

      describe "without any answers provided" do
        it {page.should have_selector("p", text:"Help your fellas out!")}
        it {page.should have_selector("h3", text:"0 Answers")}
      end

      describe "with answers provided" do
        let!(:answer){create(:answer)}
        before {visit user_path(@user)}
        it {page.should have_selector("li", text: "MyText")}
        it {page.should have_selector("h3", text: "1 Answer")}
      end

      describe "The Sidebar" do
        it "shows related courses" do
          page.should have_selector("h4", "Related Courses")
          print page.html
        end
      end




    end

    context "User Edit Page" do
      before {visit edit_user_path(@user)}
      it {page.should have_selector("img[alt='Jesse Flores']")}
      it {page.should have_selector("form")}

      describe "can update profile information" do
        let(:save){"Save Changes"}

        context "Users's personal information" do
          it {can_update_form_field("first_name", "Dave")}
          it {can_update_form_field("last_name", "Matthews")}
          it {can_update_form_field("institution", "Music Academy")}
          it {can_update_form_field("profile_summary", "Arbitrarily long text")}
        end

        context "User's educational information" do
          before do
            click_link "Your Education"
            click_link "Add a School"
          end
          it {can_update_form_field("user_professional_educations_attributes_0_school_name", "Juliard Music Academy")}
          xit {can_update_form_field("user_professional_educations_attributes_0_degree", "Masters of Music")}
          xit {can_update_form_field("user_professional_educations_attributes_0_field_of_study", "Music")}
          xit {can_update_form_field("user_professional_educations_attributes_0_enroll_date", "May 2011")}
          xit {can_update_form_field("user_professional_educations_attributes_0_graduation_date", "June 2012")}
        end

        context "User's professional information" do
          before do
            @user.professional_accomplishments.build({accomplishment_type: "Award", name: "Emmy", year: "2000"})
            visit edit_user_path(@user)
            click_link "Your Work"            
          end

          it {can_update_form_field("user_specialties_attributes_0_name", "Specialty")}
          it {can_update_select_field("Award", "user_professional_accomplishments_attributes_0_accomplishment_type")}
          it {can_update_form_field("user_professional_accomplishments_attributes_0_year", "1996")}
          it {can_update_form_field("user_professional_accomplishments_attributes_0_name", "Grammy")}
        end
      end
    end

  end

  context "When not signed in" do
    let(:user){FactoryGirl.create(:user)}

    describe "Can access users path" do
      before {visit users_path}
      it {page.should have_content("All Users")}
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

  context "With navigation tools available" do

    xit "A user can access their course info in one place" do

    end

    xit "A user can navigate from course through lesson" do

    end

    xit "A user can see active lessons" do

    end
  end

  context "With a working feed" do

    describe "Relevant suggestions" do

      xit "Suggested lessons relate to courses the user is teaching" do

      end

      xit "A user can click a link and see a lesson in context" do

      end

    end


    xit "A user can see comments provided by friends" do

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
