require 'spec_helper'

describe "InstitutionPages" do
  describe "navigate to the institution page" do
  	context "a school admin" do
  		let!(:user){create(:user_with_profile, role: "school_admin")}
  		before do
  			login(user)
  		end
  		it "allows access to the page" do
  			click_link("Manage")
  			click_link("School Info")
  			page.should have_content("Edit School Info")
  		end

  		describe "updating the Institution Information" do
  			before {visit edit_institution_path(user.institution)}
  			it {page.should have_selector("form")}
  			it "updates the user school info" do
  				expect {
  					fill_in "institution_name", with: "A new name"
  					click_button "Submit"
  				}.to change(user.institution.name).to("A new name")
  			end
  		end
  	end

  	context "a non-school_admin user with a school" do
  		let(:user){create(:user_with_profile, role: "teacher")}
  		before do
  			login(user)
  		end
  		it {page.should_not have_selector("a", "Manage")}
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
  		it {page.should_not have_selector("a", "Manage")}
  	end
  end

  describe "navigate to the faculty page" do
  	context "a school admin" do
  		let!(:user){create(:user_with_profile, role: "school_admin")}
  		before do
  			login(user)
  		end

  		describe "visiting the faculty page" do
  			describe "a working link" do
  				it "navigates to the faculty page" do
  					click_link("Manage")
  					click_link("Faculty")
  					current_path.should eq(faculty_institution_path(user.institution))
  				end
  			end
  			describe "the faculty page" do
  				before do
  					visit faculty_institution_path(user.institution)
  				end
  				it {page.should have_selector("table")}
  				it "lists all the faculty" do
  					25.times do
  						create(:user_with_profile, role: "teacher")
  					end
  					page.should have_selector("tr", id:"user_24")
  				end
  			end
  		end
  	end  	
  end

  private
  def login(user)
  	visit new_user_session_path
		fill_in "user_email", with: user.email
		fill_in "user_password", with: "password"
		click_button "Sign in"
  end
end
