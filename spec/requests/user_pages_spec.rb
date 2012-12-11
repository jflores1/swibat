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

    context "Can navigate to course pages" do

      describe "Can add a new course" do
        before {first('i.icon-plus').click}
        it {current_path.should == new_user_course_path(@user)}
      end

      describe "Can edit a current course" do
        before {first('i.icon-pencil').click}
        it {current_path.should == edit_user_course_path(@user)}
      end

      describe "Can delete a course" do
        before {first('icon-trash').click}
        it "should decrease course by one" do

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
          before{click_link "Your Education"}
          it {can_update_form_field("user_professional_educations_attributes_0_school_name", "Juliard Music Academy")}
          xit {can_update_form_field("user_professional_educations_attributes_0_degree", "Masters of Music")}
          xit {can_update_form_field("user_professional_educations_attributes_0_field_of_study", "Music")}
          xit {can_update_form_field("user_professional_educations_attributes_0_enroll_date", "May 2011")}
          xit {can_update_form_field("user_professional_educations_attributes_0_graduation_date", "June 2012")}
        end

        context "User's professional information" do
          before {click_link "Your Work"}
          it {can_update_form_field("name", "Specialty")}
          it {can_update_select_field("Certification", "accomplishment_type" )}
          it {can_update_form_field("year", "1996")}
          it {can_update_form_field("name", "Grammy")}
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
      
      page.should have_content("Specialties:")      
      page.should have_content("Education:")      
      page.should have_content("Certifications:")      
      page.should have_content("Awards:")      
      page.should have_content("Connect:")

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
    fill_in "#{form_field}", with: "#{form_text}"
    click_button save
    expect(page).to have_text("#{form_text}")
  end

  def can_update_select_field(form_option, from_field)
    select "#{form_option}", from: "#{from_field}"
    click_button save
    expect(page).to have_text("#{form_option}")
  end


end
