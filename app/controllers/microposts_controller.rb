class MicropostsController < ApplicationController
respond_to :js

	def create	
		@micropost = current_user.microposts.build(params[:micropost])
		@micropost.save!
		respond_with @micropost
	end
end
