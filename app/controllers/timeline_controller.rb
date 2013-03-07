class TimelineController < ApplicationController
  def index
  	@user = current_user
  	@activities = PublicActivity::Activity.all
  end
end
