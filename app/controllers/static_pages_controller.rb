class StaticPagesController < ApplicationController

  def teachers

  end

  def administrators

  end

  def resources

  end

  def pricing

  end

  def request_invite
  	@lead = Lead.new
  end

end
