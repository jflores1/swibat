class EvaluationCriteriaController < ApplicationController

	before_filter :load_institution_template_and_domain

	def new
		@criterion = @domain.evaluation_criteria.build		
	end

	def create
		@criterion = @domain.evaluation_criteria.build(params[:evaluation_criterion])
		if @criterion.save
		else
			render :new
		end		
	end

	def destroy
		@criterion = EvaluationCriterion.find(params[:id])
		@criterion.destroy
	end

	private
		def load_institution_template_and_domain
			@institution = Institution.find(params[:institution_id])		
			@template = EvaluationTemplate.find(params[:evaluation_template_id])	
			@domain = EvaluationDomain.find(params[:evaluation_domain_id])
		end


end
