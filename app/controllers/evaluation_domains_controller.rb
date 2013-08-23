class EvaluationDomainsController < ApplicationController
	before_filter :load_institution_and_template

	def new
		@domain = @template.evaluation_domains.build
	end

	def create
		@domain = @template.evaluation_domains.build(params[:evaluation_domain])
		if @domain.save
		else
			render :new
		end		
	end

	def destroy
		@domain = EvaluationDomain.find(params[:id])
		@domain.deleted = true;
		@domain.save
		@domain.evaluation_criteria.each do |criterion|
			criterion.deleted = true;
			criterion.save
		end
	end

	private
		def load_institution_and_template
			@institution = Institution.find(params[:institution_id])			
			@template = EvaluationTemplate.find(params[:evaluation_template_id])		
		end


end
