class CoursesController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource

  def index

  end

  def show

  end

  def new
    @course = current_user.courses.build(params[:course])
  end

  def create
    @course = current_user.courses.new(params[:course])
    if @course.save!
      flash[:notice] = "Course created successfully!"
      redirect_to user_path(current_user)
    else
      #write failing code
    end

  end

  def edit

  end

  def update

  end

  def destroy

  end

end
