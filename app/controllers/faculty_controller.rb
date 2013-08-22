class FacultyController < ApplicationController
  before_filter :load_institution, :authenticate_user!

  respond_to :html, :js, :json

  def index
    @faculty = @institution.users
    respond_with @faculty
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new_faculty_member(@institution, params[:user])
    if @user.save
      redirect_to institution_faculty_path(@institution, @user), notice: 'Successfully added faculty member'
    else
      render action: 'new_faculty_member'
    end
  end

  def import
  end

  def create_multiple
    User.import(@institution, params[:file])
    redirect_to institution_faculty_index_path(@institution), notice: 'Successfully imported faculty members'
  end

  def destroy
  end

  def load_institution
    @institution = Institution.find(params[:institution_id])
  end
end
