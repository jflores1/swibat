class EvaluationTemplateController < ApplicationController
	before_filter :load_institution
  
  def index
  	@institution.evaluation_template ||= EvaluationTemplate.create(published: false)
  	@template = @institution.evaluation_template
  end

  private
  	def load_institution
  		@institution = Institution.find(params[:institution_id])
  	end
end
