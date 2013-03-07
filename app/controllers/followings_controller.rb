class FollowingsController < ApplicationController
	#before_filter :authenticate_user!
	#load_and_authorize_resource
	respond_to :html, :js
  
  # POST
  def create
  	@followee = User.find(params[:following][:followee_id])
  	if (Following.follow(current_user, @followee))
      @following = Following.find_by_user_id_and_followee_id(current_user.id, @followee.id)
      @following.create_activity :create, owner: current_user, recipient: @followee
      flash[:notice] = "Successfully followed the user."
    else
      flash[:error] = "There was a problem while trying to follow the user."
    end  
  	respond_with @followee
  end

  # DELETE
  def destroy
  	@user = Following.find(params[:id]).followee
  	current_user.unfollow!(@user)
  end
end
