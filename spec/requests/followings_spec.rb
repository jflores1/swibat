require 'spec_helper'

describe "FollowingActions" do
  before do
    @followee = FactoryGirl.create(:user, :email => "marjan@test.com", :first_name => "marjan", :last_name => "georgiev")    
  end

  context "Accessing the User Page" do
    describe "An authorized user tries to view profile pages" do
      it "should allow access" do
        sign_in_as_a_valid_user        
        get user_path(:id => @followee.id)
        response.status.should be(200)
      end
    end
  end
    
  context "when viewing a users's profile" do    
    describe "who you do not follow" do
      before do
        sign_in_via_form
        visit user_path(@followee)
      end

      it "should display the follow button" do        
        page.should have_content("Follow")         
        page.should_not have_content("Unfollow")
      end

      it "should have a working follow button" do        
        click_link "Follow"
        @user.followings.count.should == 1
        @followee.followers.count.should == 1        
      end

    end

    
    describe "who you follow" do
      before do
        sign_in_via_form
        Following.follow(@user, @followee)                
        visit user_path @followee
      end

      it "should display the unfollow button" do
        page.should_not have_content("Follow")         
        page.should have_content("Unfollow")
      end

      it "should have a working unfollow button" do        
        click_link "Unfollow"
        @user.followings.count.should == 0
        @followee.followers.count.should == 0        
      end
    end

  end

end

