class EvaluationTemplateController < ApplicationController
	before_filter :load_institution
  
  def index
  	@institution.evaluation_template ||= EvaluationTemplate.create_default_template_for(@institution)
  	@template = @institution.evaluation_template
  end

  private
  	def load_institution
  		@institution = Institution.find(params[:institution_id])
  	end
end
