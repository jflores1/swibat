require 'spec_helper'

describe "InstitutionPages" do
  describe "navigate to the institution page" do
  	context "a school admin" do
  		let!(:user){create(:user_with_profile, role: "school_admin")}
  		before do
  			login(user)
  		end
  		it "allows access to the page" do
  			click_link("manage")
  			click_link("School Info")
  			current_path.should eq(institution_path(user.institution))
  		end

      describe "it lists the faculty members" do
        let(:institution){user.institution}
        before do
          visit institution_path(institution)
        end
        it "lists all the faculty" do
          25.times do
            build_stubbed(:user_with_profile, role: "teacher", institution: institution)
          end
          page.should have_selector("tr", id:"user_24")
        end
        it "allows links to add an evaluation" do
          build_stubbed(:user_with_profile, role: "teacher", institution: institution)
          first('a.add-evaluation').click
          current_path.should be(eval_user_path(first_user))
        end
      end

  		#TODO: Do we still give users the opportunity to edit information? What if they're school isn't listed?
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
  		let!(:user){create(:user_with_profile, role: "school_admin")}
  		before do
  			login(user)
  		end

      #TODO: This presupposes that the user is associated with a school. We need to manage the case where there isn't a school yet selected.
  		describe "visiting the faculty page" do
  			describe "a working link" do
  				it "navigates to the faculty page" do
  					click_link("manage")
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

  describe "uploading a video for a teacher" do
    context "a school admin" do
      let(:school){faculty_member.institution}
      let(:user){create(:user_with_profile, role: "school_admin")}
      let(:faculty_member){create(:user_with_profile, first_name:"Bob", role:"teacher")}
      before do
        login(user)
        visit faculty_institution_path(school)
      end
      it "navigates to the user's video index" do
        find("a.upload-video").click
        current_path.should eq(videos_user_path(faculty_member))
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
