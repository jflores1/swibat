class InstitutionsController < ApplicationController
	before_filter :authenticate_user!
	before_filter :load_institution
	load_and_authorize_resource

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
end

def load_institution
	@institution = Institution.find(params[:id])
end

end
