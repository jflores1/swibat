require 'spec_helper'

describe Following do
	before do
	  @user = FactoryGirl.create(:user)
	  @followee = FactoryGirl.create(:user, :email => "marjan@test.com", :first_name => "marjan", :last_name => "georgiev")
	end

	describe "With Invalid information" do				
		before do 
			@following = Following.new(:user => @user, :followee => @followee)
		end

    describe "Without a sender and receiver" do
    	before do 
				@following = Following.new(:user => nil, :followee => nil)
			end
      it "shouldn't be valid" do
      	@following.should_not be_valid
    	end
      
      it "should throw an error on save" do
      	expect {@following.save!}.to raise_error(ActiveRecord::RecordInvalid)
      end
      
      it "should have the proper error messages" do
      	@following.should have(1).error_on(:user)
      	@following.should have(1).error_on(:followee)
      end
    end

  end


  describe "When following a user" do
		it "doesn't let users follow themselves" do
		  expect { Following.follow(@user, @user)}.to_not change{Following.count}
		end

		it "successfully creates the following object" do
		  expect { Following.follow(@user, @followee) }.to change{Following.count}.by(1)		  
		end

		it "doesn't allow repeated requests" do
			Following.follow(@user, @followee)
			Following.follow(@user, @followee)
			@user.followings.count.should == 1
		end
	end

	describe "When unfollowing a user" do
		it 'successfully deletes the following object' do
			Following.follow(@user, @followee)
			Following.unfollow(@user, @followee)
			@user.followings.count.should == 0
		end

	end

end