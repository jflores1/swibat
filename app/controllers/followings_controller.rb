class FollowingsController < ApplicationController
  
  # POST
  def follow
  	followee = User.find(params[:id])
		if (Following.follow(current_user, followee))
			flash[:notice] = "Successfully followed the user."
			redirect_to :back
		else
			flash[:error] = "There was a problem while trying to follow the user."
    	redirect_to :back
		end
  end

  # DELETE
  def destroy
  	following = Following.find(params[:id])
		if following.destroy
			flash[:notice] = "Successfully unfollowed user."
			redirect_to :back
		else
			flash[:error] = "There was a problem while trying to unfollow the user."
			redirect_to :back
		end
  end
end
