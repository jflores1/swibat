require 'spec_helper'

describe "FriendshipActions" do
  before do
    @friend = FactoryGirl.create(:user, :email => "marjan@test.com", :first_name => "marjan", :last_name => "georgiev")    
  end

  context "Accessing the User Page" do
    describe "An authorized user tries to view profile pages" do
      it "should allow access" do
        sign_in_as_a_valid_user        
        get user_path(:id => @friend.id)
        response.status.should be(200)
      end

    end

    describe "An unauthorized user tries to get access" do
      it "should not allow access" do        
        get user_path @friend        
        response.status.should be(302)
      end
    end
  end
    
  context "when viewing a friend's profile" do    
    describe "who is not your friend" do
      before do
        sign_in_via_form
        visit user_path(@friend)
      end

      it "should display the add friend button" do        
        page.should have_content("Add as Friend")         
        page.should_not have_content("Unfriend")
        page.should_not have_content("Accept Friend Request")
        page.should_not have_content("Decline Friend Request")
        page.should_not have_content("Revoke Friend Request")
      end

      it "should have a working add friend button" do        
        click_link "Add as Friend"
        @user.sent_friend_requests.count.should == 1
        @friend.incoming_friend_requests.count.should == 1
        @user.incoming_friend_requests.count.should == 0
      end

    end

    describe "who has sent you a friend request" do
      before do
        sign_in_via_form
        Friendship.request(@friend, @user)
        visit user_path @friend
      end

      it "should display the accept and decline buttons" do
        page.should_not have_content("Add as Friend")         
        page.should_not have_content("Unfriend")
        page.should have_content("Accept Friend Request")
        page.should have_content("Decline Friend Request")
        page.should_not have_content("Revoke Friend Request")
      end

      it "should have a working accept friend button" do        
        click_link "Accept Friend Request"
        @user.friends.count.should == 1        
        @user.incoming_friend_requests.count.should == 0
      end

      it "should have a working decline friend button" do        
        click_link "Decline Friend Request"
        @user.friends.count.should == 0        
        @user.incoming_friend_requests.count.should == 0
      end
    end

    describe "who you have sent a friend request to" do
      before do
        sign_in_via_form
        Friendship.request(@user, @friend)        
        visit user_path @friend
      end

      it "should display the revoke request" do
        page.should_not have_content("Add as Friend")         
        page.should_not have_content("Unfriend")
        page.should_not have_content("Accept Friend Request")
        page.should_not have_content("Decline Friend Request")
        page.should have_content("Revoke Friend Request")
      end

      it "should have a working revoke friend request button" do        
        @user.sent_friend_requests.count.should == 1
        click_link "Revoke Friend Request"        
        @user.sent_friend_requests.count.should == 0
      end
    end

    describe "who is your friend" do
      before do
        sign_in_via_form
        Friendship.request(@user, @friend)        
        @friend.incoming_friend_requests.first.accept(@friend)
        visit user_path @friend
      end

      it "should display unfriend" do
        page.should_not have_content("Add as Friend")         
        page.should have_content("Unfriend")
        page.should_not have_content("Accept Friend Request")
        page.should_not have_content("Decline Friend Request")
        page.should_not have_content("Revoke Friend Request")
      end
    end

  end

end

