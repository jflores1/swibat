class ActivitiesController < ApplicationController
  before_filter :find_lesson

  def new
    @activity = Activity.new
  end

  def create
    @activity = @lesson.activities.create(params[:activity])
    if @activity.save!
      respond_to do |format|
        format.js {render js: %(window.location.pathname='#{unit_lesson_path(@unit, @lesson)}')}
      end
    else
      flash[:error] = "Oops. Didn't save"
    end
  end

  def destroy
    @activity = @lesson.activities.find(params[:id])
    @activity.destroy
    respond_to do |format|
      format.js
    end
  end

  def find_lesson
    @lesson = Lesson.find(params[:lesson_id])
    @unit = @lesson.unit
  end

end
