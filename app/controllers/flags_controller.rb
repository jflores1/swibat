class FlagsController < ApplicationController
	load_and_authorize_resource
  before_filter :authenticate_user!

  def flag
  	@flaggable = Flag.find_flaggable(params[:flaggable_type], params[:flaggable_id])
  	@flag = Flag.build_from(@flaggable, current_user.id)

    respond_to do |format|
      if @flag.save
        format.html { redirect_to(:back, :notice => 'Resource was successfully flagged.') }        
      else
      	format.html do
      		flash[:error] = @flag.errors.first[1].to_s	
      		redirect_to :back
      	end
      end
    end
  end

end