class LeadsController < ApplicationController

  def new
    @lead = Lead.new
  end

  def create
    @lead = Lead.new(params[:lead])
    if @lead.save!
      flash[:notice] = "Thanks for your interest! (Please make sure you can accept email from swibat.com to get your invite)"
      respond_to do |format|
        format.js
      end
    else
      flash[:notice] = "Sorry, you might have missed something on the form. Try again!"
      render 'new'
    end
  end
end
