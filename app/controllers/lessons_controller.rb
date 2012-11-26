class LessonsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :find_current_unit
  load_and_authorize_resource

  def new
    @lesson = @unit.lessons.new
  end

  def create
    @lesson = @unit.lessons.new(params[:lesson])
    if @lesson.save
      #
    else
      #
    end
  end

  def find_current_unit
    @course = current_user.courses.find(params[:course_id])
    @unit = Course.units.find(params[:unit_id])
  end

end
