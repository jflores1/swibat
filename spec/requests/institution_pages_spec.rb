require 'spec_helper'

describe "InstitutionPages" do
  describe "navigate to the institution page" do
  	context "a school admin" do
  		before do
  			sign_in_as_admin
  		end
  		it "allows access to the page" do
  			click_link("Manage")
  			click_link("School Info")
  			current_path.should eq(edit_institution_path(@user.institution))
  		end

  		#TODO: Do we still give users the opportunity to edit information? What if their school isn't listed?
      describe "updating the Institution Information" do
  			before {visit edit_institution_path(@user.institution)}
  			it {page.should have_selector("form")}
  			it "updates the user school info" do
  				expect {
  					fill_in "institution_name", with: "A new name"
  					click_button "Submit"
  				}.to change(@user.institution.name).to("A new name")
  			end
  		end
  	end

  	context "a non-school_admin user with a school" do
  		let(:user){create(:user_with_profile, role: "teacher")}
  		before do
  			login(user)
  		end
  		it {page.should_not have_selector("a", "manage")}
  	end

  	context "a user without a school" do
  		before do
  			sign_in_via_form
  		end
  		it "does not allow access to the page" do
  			@user.create_institution(name:"School")
  			page.should_not have_selector("a", text: "School Info")
  		end
  	end

  	context "a user not signed in" do
  		let(:user){create(:user_with_profile)}
  		before {visit user_path(user)}
  		it {page.should_not have_selector("a", "manage")}
  	end
  end

  describe "navigate to the faculty page" do
  	context "a school admin" do
  		before do
  			sign_in_as_admin
  		end

      #TODO: This presupposes that the user is associated with a school. We need to manage the case where there isn't a school yet selected.
  		describe "visiting the faculty page" do
  			describe "the faculty page" do
  				before do
            25.times do
              create(:user, role: "teacher", first_name: "Teacher", institution: @user.institution)
            end
  					visit faculty_institution_path(@user.institution)
  				end
  				it {page.should have_selector("table")}
  				it "lists all the faculty" do
  					page.should have_selector("tr", id:"user_24")
  				end
          it "navigates to faculty page" do
            find_link("Teacher").click
            page.should have_selector("a", text: "Teacher")
          end
          it "navigates to the observations page" do
            find_link("0").click
            page.should have_content("Teacher's Observations")
          end
          describe "navigation to observations" do
            context "the user hasn't created an observation template yet" do
              it "navigates to the evaluation templates path" do
                find_link("New Observation").click
                find_link("Add Observation Template").click
                current_path.should eq(institution_evaluation_templates_path(@user.institution))
              end
            end
            context "the user has created a template" do
              #TODO: Create a Factory of an evaluation template so we can test this.
              xit "navigates to teh evaluation templates path"
              xit "page lists available templates"
            end
          end
          it "allows user to add a video" do
            find_link("New Video").click
            page.should have_content("Teacher's Videos")
          end
  			end
  		end
  	end  	
  end

  describe "uploading a video for a teacher" do
    context "a school admin" do
      before(:all) do
        sign_in_as_admin
      end
      let(:teacher){create(:user, role: "teacher", first_name: "Teacher", institution: @user.institution)}
      before {visit videos_user_path(teacher)}
      it "navigates to the new video form" do
        click_link("Upload a new video")
        page.should have_selector("h2", text: "Upload a new video for Teacher Flores")  
      end
      
    end
  end

  private
  def login(user)
  	visit new_user_session_path
		fill_in "user_email", with: user.email
		fill_in "user_password", with: "password"
		click_button "Login"
  end
end
