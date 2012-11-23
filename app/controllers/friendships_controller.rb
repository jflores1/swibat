class FriendshipsController < ApplicationController
	before_filter :authenticate_user!

	def index
		@friendships = current_user.friendships
		@sent_friend_requests = current_user.sent_friend_requests
		@incoming_friend_requests = current_user.incoming_friend_requests
	end

	# POST
	def add		
		friend = User.find(params[:id])
		if (Friendship.request(current_user, friend))
			flash[:notice] = "Successfully sent friend request."
			redirect_to friend
		else
			flash[:error] = "There was a problem while trying to send the friend request."
    		redirect_to friend
		end
	end

	# POST
	def accept
		friend_request = Friendship.find(params[:id])
		if (friend_request.accept(current_user))
			flash[:notice] = "Successfully accepted friend request."
			redirect_to friendships_url
		else
			flash[:error] = "There was a problem while trying to accept the friend request."
    		redirect_to friendships_url
		end
	end

	# DELETE
	def destroy
		friendship = Friendship.find(params[:id])
		if friendship.remove(current_user)
			flash[:notice] = "Successfully removed friendship."
			redirect_to friendships_url
		else
			flash[:error] = "There was a problem while trying to remove the friendship."
			redirect_to friendships_url
		end
	end

end
