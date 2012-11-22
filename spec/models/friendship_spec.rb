require 'spec_helper'

describe Friendship do
	before do
	  @user = FactoryGirl.create(:user)
	  @friend = FactoryGirl.create(:user, :email => "marjan@test.com", :first_name => "marjan", :last_name => "georgiev")
	end
	describe "With Invalid information" do				
		before do 
			@friendship = Friendship.new(:user => @user, :friend => @friend, :status => 'accepted')
		end

    describe "Without a sender and receiver" do
    	before do 
				@friendship = Friendship.new(:user => nil, :friend => nil, :status => 'accepted')
			end
      it "shouldn't be valid" do
      	@friendship.should_not be_valid
    	end
      
      it "should throw an error on save" do
      	expect {@friendship.save!}.to raise_error(ActiveRecord::RecordInvalid)
      end
      
      it "should have the proper error messages" do
      	@friendship.should have(1).error_on(:user)
      	@friendship.should have(1).error_on(:friend)
      end
    end

    describe "With an invalid status" do
    	before { @friendship.status = '' }

    	it "shouldn't be valid" do
    		@friendship.should_not be_valid
    	end

    	it "should throw an error on save" do
      	expect {@friendship.save!}.to raise_error(ActiveRecord::RecordInvalid)
      end

      it "should have the proper error messages" do
      	@friendship.should have(2).errors_on(:status)      	
      end
    end

  end

	describe "When sending a friend request" do
		it "doesn't let users befriend themselves" do
		  expect { Friendship.request(@user, @user)}.to_not change{Friendship.count}
		end

		it "successfully creates the friend request" do
		  expect { Friendship.request(@user, @friend) }.to change{Friendship.count}.by(2)		  
		end

		it "doesn't allow repeated requests" do
			Friendship.request(@user, @friend)
			Friendship.request(@user, @friend)
			@user.sent_friend_requests.count.should == 1
			@friend.incoming_friend_requests.count.should == 1
		end

		it "sets the correct request statuses to pending and requested" do
		  Friendship.request(@user, @friend)
		 	@user.sent_friend_requests.first.status.should == 'pending'
		 	@friend.incoming_friend_requests.first.status.should == 'requested'
		end
	end

	describe "When accepting a friend request" do
		before do
			Friendship.request(@user, @friend)
		end

		it "doesn't let the requester accept the request too" do
		  expect { @user.sent_friend_requests.first.accept(@user) }.to_not change{@user.friends.count}
		end

		it "successfully accepts the request" do
			@friend.incoming_friend_requests.first.accept(@friend)
			@friend.friends.count.should == 1
			@user.friends.count.should == 1
			@user.friends.first.should == @friend
			@user.friendships.first.status.should == 'accepted'
		end		
	end

end
