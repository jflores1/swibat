require 'spec_helper'

describe "Profile" do

	before do 
		sign_in_via_form
		@other_person = FactoryGirl.create(:user, :email => "friend@test.com", :first_name => "Friend", :last_name => "Friendovski")
	end

	describe "When on my profile page" do		
		before {visit user_path @user}
		it "should display edit profile button" do			
			page.should have_xpath('//a[text() = "Edit Profile"]')
		end

		it "clicking the button should take me to the edit user page" do			
			page.find(:xpath, '//a[text() = "Edit Profile"]').click
			current_url.should == edit_user_url(@user)
		end
	end

	describe "When on the edit profile page" do
		before {visit edit_user_path @user}

		it "should display edit user form" do
			page.should have_selector("form")
		end

		describe "With valid attributes" do
			it "should successfully update user" do
				fill_in 'user_first_name',     with: "Marjan"
				fill_in 'user_last_name',    	 with: "Georgiev"
				fill_in 'user_institution',    with: "Jane Sandanski"
				click_button "Update"			
				@user.reload
				current_url.should == user_url(@user)	
				@user.first_name.should == "Marjan"
				@user.last_name.should == "Georgiev"
				@user.institution.should == "Jane Sandanski"				
			end
		end

		describe "With invalid attributes" do
			it "should display error" do
				fill_in 'user_first_name',     with: ""
				fill_in 'user_last_name',    	 with: ""
				fill_in 'user_institution',    with: ""
				click_button "Update"				
				page.should have_selector('#error_explanation')
				page.should have_content("First name can't be blank")
				page.should have_content("Last name can't be blank")
				page.should have_content("Institution can't be blank")
			end
		end

	end
end