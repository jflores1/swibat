require 'spec_helper'

describe "Commenting" do

	before do 
		sign_in_via_form		
		@not_friend = FactoryGirl.create(:user, :email => "marjan@test.com", :first_name => "marjan", :last_name => "georgiev")
		@friend = FactoryGirl.create(:user, :email => "friend@test.com", :first_name => "Friend", :last_name => "Friendovski")
		Friendship.create(:user => @user, :friend => @friend, :status => 'accepted')
		Friendship.create(:user => @friend, :friend => @user, :status => 'accepted')
		@grade = FactoryGirl.create(:grade, :grade_level => 'Kindergarden')
		@friend_commentable = FactoryGirl.create(:course, :user => @friend, :grade => @grade)
		@not_friend_commentable = FactoryGirl.create(:course, :user => @not_friend, :grade => @grade)
		@my_commentable = FactoryGirl.create(:course, :user => @user, :grade => @grade)
  end

	context "when on a friend's commentable page" do
		before { visit course_path @friend_commentable }
		let(:comment_button){"Leave a Comment"}

		it "should display the comments form" do
			page.should have_selector('#new_comment')						
		end

		it "should allow me to post comments" do
			fill_in 'comment_body',     with: "this is my comment"
			expect {click_button comment_button}.to change(Comment, :count).by(1)
			comment = Comment.last
			comment.body.should == "this is my comment"
			comment.user.should == @user
		end

		it "should allow me to delete my comments" do
			my_comment = Comment.build_from(@friend_commentable, @user.id, "this is my comment")
			my_comment.save
			visit course_path @friend_commentable
			page.should have_content "this is my comment"
			page.should have_xpath('//*[@id="comments"]//a[text() = "Delete"]')
		end

		it "should not allow me to delete other people's comments" do
			my_comment = Comment.build_from(@friend_commentable, @friend.id, "this is my comment")
			my_comment.save
			visit course_path @friend_commentable
			page.should have_content "this is my comment"
			page.should_not have_xpath('//*[@id="comments"]//a[text() = "Delete"]')
		end
	end

	context "when not on a friend's commentable page" do
		before { visit course_path @not_friend_commentable }
		let(:comment_button){"Leave a Comment"}

		it "should let me see other people's comments" do
			page.should have_selector('#comments')						
		end

		#it "should not display the comments form" do
		#	page.should_not have_selector('#new_comment')
		#end

		it "should not allow me to delete other people's comments" do
			comment = Comment.build_from(@not_friend_commentable, @friend.id, "this is my comment")
			comment.save
			visit course_path @not_friend_commentable
			page.should have_content "this is my comment"
			page.should_not have_xpath('//*[@id="comments"]//a[text() = "Delete"]')
		end
	end

	context "when on a my own commentable page" do
		before { visit course_path @my_commentable }
		let(:comment_button){"Leave a Comment"}

		it "should display the comments form" do
			page.should have_selector('#new_comment')						
		end

		it "should allow me to post comments" do
			fill_in 'comment_body',     with: "this is my comment"
			expect {click_button comment_button}.to change(Comment, :count).by(1)
			comment = Comment.last
			comment.body.should == "this is my comment"
			comment.user.should == @user
		end

		it "should allow me to delete my comments" do
			my_comment = Comment.build_from(@my_commentable, @user.id, "this is my comment")
			my_comment.save
			visit course_path @my_commentable
			page.should have_content "this is my comment"
			page.should have_xpath('//*[@id="comments"]//a[text() = "Delete"]')
		end

		it "should not allow me to delete other people's comments" do
			my_comment = Comment.build_from(@my_commentable, @friend.id, "this is my comment")
			my_comment.save
			visit course_path @my_commentable
			page.should have_content "this is my comment"
			page.should have_xpath('//*[@id="comments"]//a[text() = "Delete"]')
		end
	end

end