class EvaluationDomainsController < ApplicationController
	before_filter :load_institution

	def new
		@domain = @institution.evaluation_template.evaluation_domains.build
	end

	def create
		@domain = @institution.evaluation_template.evaluation_domains.build(params[:evaluation_domain])
		if @domain.save
		else
			render :new
		end		
	end

	def destroy
		@domain = EvaluationDomain.find(params[:id])
		@domain.destroy
	end

	private
		def load_institution
			@institution = Institution.find(params[:institution_id])			
		end


end
