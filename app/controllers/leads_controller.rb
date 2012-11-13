class LeadsController < ApplicationController

  def new
    @lead = Lead.new
  end

  def create
    @lead = Lead.new(params[:lead])
    if @lead.save!
      respond_to do |format|
        format.js
      end
    else
      flash[:notice] = "Sorry, you might have missed something on the form. Try again!"
      render 'new'
    end
  end
end
