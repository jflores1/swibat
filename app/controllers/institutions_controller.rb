class InstitutionsController < ApplicationController
	before_filter :authenticate_user!
	before_filter :load_institution, except: [:autocomplete_institution_name]
	load_and_authorize_resource
  respond_to :html, :js, :json

	autocomplete :institution, :name, :full => true, :display_value => :display_name

	def show
		
	end

	def edit
		
	end

	def update
		@institution.update_attributes(params[:institution])
		redirect_to :back #TODO: This needs a real place to go back to, maybe a Show page?
	end

	def faculty
		@faculty = @institution.users
    respond_with @faculty
	end

	def eval_template
		@eval_template = @institution.evaluation_template
	end

	def load_institution
		@institution = Institution.find(params[:id])
	end

end
