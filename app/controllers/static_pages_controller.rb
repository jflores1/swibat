class StaticPagesController < ApplicationController

  def teachers

  end

  def administrators

  end

  def home
    render layout: 'photo_background'
    
  end

  def resources

  end

  def pricing

  end

  def request_invite
  	@lead = Lead.new
  end

  def features
    
  end

end
