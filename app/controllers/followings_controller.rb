class FollowingsController < ApplicationController
	#before_filter :authenticate_user!
	#load_and_authorize_resource
	respond_to :html, :js
  
  # POST
  def create
  	@user = User.find(params[:following][:followee_id])
  	current_user.follow!(@user)
  	respond_with @user
  end

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
  	@user = Following.find(params[:id]).followee
  	current_user.unfollow!(@user)
  end
end
