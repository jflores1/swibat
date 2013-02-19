class EvaluationsController < ApplicationController
  before_filter :load_institution

  
  def index

  end

  private
  	def load_institution
  		@institution = Institution.find(params[:institution_id])
  	end

end
