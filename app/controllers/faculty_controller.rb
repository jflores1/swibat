class FacultyController < ApplicationController
  before_filter :load_institution, :authenticate_user!

  respond_to :html, :js, :json

  def index
    @faculty = @institution.users
    respond_with @faculty
  end

  def show
    @user = User.find(params[:id])

    @templates = @user.teacher_evaluations.all.collect {|ev| ev.evaluation_template}
    @templates.uniq!

    @data = [];

    @templates.each do |template|
      template_hash = {}
      @evaluations = @user.teacher_evaluations.where(evaluation_template_id: template.id)
      template_hash[:template_name] = template.name
      template_hash[:template_id] = template.id
      template_hash[:domains] = []
      template.evaluation_domains.each do |domain|
        domain_hash = {name: domain.name}
        score = 0
        @evaluations.each do |ev|
          score += domain.calculate_score(ev)
        end
        score /= @evaluations.count.to_f
        domain_hash[:score] = score        
        template_hash[:domains] << domain_hash if domain_hash[:score] > 0
      end
      @data << template_hash
    end
    @chart_data = @data.to_json
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

  def autocomplete_user_full_name
    @result = @institution.users.find_by_full_name(params[:term]).collect{|u| {id: u.id, label: u.full_name, value: u.full_name}}
    respond_with @result 
  end

end
