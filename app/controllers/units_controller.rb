class UnitsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :find_current_course, :except => [:vote]
  load_and_authorize_resource

  def show
    @course = Course.find(params[:course_id])
    @user = @course.user
    @unit = Unit.find(params[:id])
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
      flash[:notice] = "Sorry, there was a mistake with the form"
      render 'new'
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


  private

    def find_current_course
      @course = Course.find(params[:course_id])
    end

end
