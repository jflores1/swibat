class MicropostsController < ApplicationController
respond_to :js

	def index
		@user = User.find(params[:user_id])
		@microposts = @user.feed.where('id > ?', params[:after].to_i)
	end

	def create	
		@micropost = current_user.microposts.build(params[:micropost])
		@micropost.save!
		respond_with @micropost
	end
end
