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

	def new_faculty_member
		@user = User.new		
	end

	def create_faculty_member
		@user = User.new_faculty_member(@institution, params[:user])
		if @user.save
			redirect_to faculty_institution_path(@institution), notice: 'Successfully added faculty member'
		else
			render action: 'new_faculty_member'
		end
	end

	def import_faculty

	end

	def create_faculty_members
		User.import(@institution, params[:file])
  	redirect_to faculty_institution_path(@institution), notice: 'Successfully imported faculty members'
	end

	def load_institution
		@institution = Institution.find(params[:id])
	end

end
