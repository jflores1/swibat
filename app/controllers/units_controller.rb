class UnitsController < ApplicationController
  before_filter :authenticate_user!, except: [:show]
  before_filter :find_current_course, :except => [:vote, :new_unit_content, :new_unit_skill]
  load_and_authorize_resource
  skip_authorize_resource only: :show

  def show
    @course = Course.find(params[:course_id])
    @user = @course.user
    @unit = Unit.find(params[:id])

    @similar_units_based_on_name = Objective.find_similar_objectiveables([@unit.to_s], "Unit", "name").first(5)
    @similar_units_based_on_name.delete_if {|c| c[:objectiveable].id == @unit.id}    
    objectives = @unit.objectives.collect {|o| o.objective }
    @similar_units_based_on_objectives = Objective.find_similar_objectiveables(objectives, "Unit", "objectives").first(5)
    @similar_units_based_on_objectives.delete_if {|c| c[:objectiveable].id == @unit.id}    
  end

  def new
    @unit = @course.units.new
    @unit.objectives.build
    @unit.assessments.build
  end

  def create
    @unit = @course.units.new(params[:unit])
    if @unit.save && params[:submit]
      redirect_to course_path(@course)
    elsif @unit.save && params[:move_on]
      redirect_to new_unit_lesson_path(@unit)
    else
      render 'new'
    end
  end

  def edit
    @unit = @course.units.find(params[:id])
  end

  def update
    @unit = @course.units.find(params[:id])
    if @unit.update_attributes(params[:unit])
      redirect_to course_unit_path(@course, @unit)
    else
      flash[:error] = "Sorry, there was a mistake with the form"
      redirect_to edit_course_unit_path(@course, @unit)
    end

  end

  def vote
    @unit = Unit.find(params[:id])
    if params[:type] == 'clear'
      @unit.delete_evaluation(:votes, current_user)
    else
      value = params[:type] == "up" ? 1 : -1      
      @unit.add_or_update_evaluation(:votes, value, current_user)
    end
    redirect_to :back, notice: "Thank you for voting"   
  end

  def new_unit_content
    @objective = @unit.objectives.build
  end

  def new_unit_skill
    @objective = @unit.objectives.build
  end


  private

    def find_current_course
      @course = Course.find(params[:course_id])
    end

end
