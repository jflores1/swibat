class LessonsController < ApplicationController
  before_filter :authenticate_user!, except: [:show]
  before_filter :find_current_unit, :except => [:vote, :lesson_content, :lesson_skills, :standards, :save_standards, :update_journal_entry]
  load_and_authorize_resource
  skip_authorize_resource only: :show
  respond_to :html, :json

  def show
    @lesson = Lesson.find(params[:id])
    @course = @unit.course
    @user = @course.user
    @journal_entry = @lesson.journal_entry || JournalEntry.new

    @similar_lessons_based_on_name = Objective.find_similar_objectiveables([@lesson.to_s], "Lesson", "name").first(5)
    @similar_lessons_based_on_name.delete_if {|c| c[:objectiveable].id == @lesson.id}    
    objectives = @lesson.objectives.collect {|o| o.objective }
    @similar_lessons_based_on_objectives = Objective.find_similar_objectiveables(objectives, "Lesson", "objectives").first(5)
    @similar_lessons_based_on_objectives.delete_if {|c| c[:objectiveable].id == @lesson.id} 
  end

  def new
    @lesson = @unit.lessons.new
    @lesson.resources.build
    @lesson.objectives.build
    @lesson.assessments.build
  end

  def create
    @lesson = @unit.lessons.build(params[:lesson])
    if @lesson.save && params[:add_another_lesson]
      redirect_to new_unit_lesson_path(@unit)
    elsif @lesson.save && params[:return_to_profile]
      redirect_to unit_lesson_path(@unit, @lesson)
    else
      render 'new'
    end
  end

  def edit
    @lesson = Lesson.find(params[:id])
    @lesson.resources.build
    @lesson.objectives.build
    @lesson.assessments.build
  end

  def update
    @lesson = Lesson.find(params[:id])
    @lesson.update_attributes(params[:lesson])
    respond_with [@unit, @lesson]
  end

  def destroy
    @lesson = Lesson.find(params[:id])
    @lesson.destroy
    redirect_to user_path(current_user)
  end

  def vote
    @lesson = Lesson.find(params[:id])
    if params[:type] == 'clear'
      @lesson.delete_evaluation(:votes, current_user)
    else
      value = params[:type] == "up" ? 1 : -1      
      @lesson.add_or_update_evaluation(:votes, value, current_user)
    end
    redirect_to :back, notice: "Thank you for voting"   
  end

  def lesson_content
    @lesson = @lesson.objectives.build(params[:objective])
    @lesson.save!
  end

  def lesson_skills
    @lesson = @lesson.objectives.build(params[:objective])
    @lesson.save!
  end

  def standards
    @lesson = Lesson.find(params[:id])
    @grades = Grade.all
    @domains = EducationalDomain.where(:parent_id => nil)
  end

  # POST
  def save_standards
    @lesson = Lesson.find(params[:id])
    @lesson.lesson_standards.destroy_all
    standard_ids = params[:standards].split(',') || []
    standard_ids.each do |id|
      @lesson.educational_standards << EducationalStandard.find(id)      
    end

    redirect_to [@lesson.unit, @lesson]
  end

  # POST
  def update_journal_entry
    @lesson = Lesson.find(params[:id])    
    @journal_entry = JournalEntry.find_or_initialize_by_lesson_id(@lesson.id)
    @journal_entry.update_attributes(params[:journal_entry])
    @journal_entry.save
  end

  private

  def find_current_unit
    @unit = Unit.find(params[:unit_id])
  end

end
