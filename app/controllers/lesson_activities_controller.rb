class LessonActivitiesController < ApplicationController
  before_filter :find_lesson

  def new
    @activity = LessonActivity.new
  end

  def create
    @activity = @lesson.lesson_activities.create(params[:lesson_activity])
    if @activity.save!
      respond_to do |format|
        format.js
      end
    else
      flash[:error] = "Oops. Didn't save"
    end
  end

  def destroy
    @activity = @lesson.lesson_activities.find(params[:id])
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
