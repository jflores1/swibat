class LessonsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :find_current_unit, :except => [:vote]
  load_and_authorize_resource

  def show
    @lesson = Lesson.find(params[:id])
    @course = @unit.course
    @user = @course.user
    
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
      redirect_to user_path(current_user)
    else
      flash[:error] = "Sorry, there was a mistake with the form"
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
    if @lesson.update_attributes(params[:lesson])
      redirect_to {unit_lesson_path [@unit, @lesson], notice: 'Lesson was successfully updated.' }
    else
      render action: "edit"
    end
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

  private

  def find_current_unit
    @unit = Unit.find(params[:unit_id])
  end

end
