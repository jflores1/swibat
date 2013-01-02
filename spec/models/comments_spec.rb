require 'spec_helper'
require "cancan/matchers"

describe Comment do

	describe "Attributes and relations" do
    it {should respond_to(:flags)}
    it {should respond_to(:user)}        
  end

	describe 'authorization' do
    let!(:user){create(:user)}
    let!(:not_friend){create(:user, :email => "marjan@test.com", :first_name => "marjan", :last_name => "georgiev")}
    let!(:friend){create(:user, :email => "friend@test.com", :first_name => "Friend", :last_name => "Friendovski")}
    let!(:commentable){create(:course, user: user)}

		before do
			Friendship.create(:user => user, :friend => friend, :status => 'accepted')
			Friendship.create(:user => friend, :friend => user, :status => 'accepted')
		end

		context 'when on a profile who is not a friend' do
			before {@ability = Ability.new(not_friend)}

			#it 'should not allow commenting' do
			#	comment = Comment.build_from(commentable, not_friend.id, "this is my comment")
			#	@ability.should_not be_able_to(:create, comment)
			#end

			it "should not allow deleting other people's comments" do				
				comment = Comment.build_from(commentable, friend.id, "this is my comment")
				comment.save
				@ability.should_not be_able_to(:destroy, comment)
			end

			it "should allow flagging" do
				comment = Comment.build_from(commentable, friend.id, "this is my comment")
				comment.save
				flag = Flag.build_from(comment, user)
				expect {flag.save}.to change(comment.flags, :count).by(1)
			end
		end

		context 'when on my own profile' do
			before {@ability = Ability.new(user)}

			it 'should allow me to create and delete my own comments' do				
				comment = Comment.build_from(commentable, user.id, "this is my comment")
				@ability.should be_able_to(:manage, comment)
			end

			it "should allow me to create and delete other people's comments" do				
				comment = Comment.build_from(commentable, friend.id, "this is my comment")
				comment.save
				@ability.should be_able_to(:manage, comment)
			end
		end

		context 'when on a friend profile' do
			before {@ability = Ability.new(friend)}

      describe "comment creation" do
        let!(:comment) {Comment.build_from(commentable, friend.id, "this is my comment")}
        before(:each){
          comment.save
        }

        it 'should allow me to create and delete my own comments' do
          @ability.should be_able_to(:create, comment)
          @ability.should be_able_to(:destroy, comment)
        end

        it 'notifies the owner of the new comment' do
          last_email.to.should include(commentable.user.email)
        end

      end

			it "should not allow me to delete other people's comments" do				
				comment = Comment.build_from(commentable, user.id, "this is my comment")
				comment.save
				@ability.should_not be_able_to(:destroy, comment)
      end

    end

	end

end
