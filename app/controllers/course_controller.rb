class CourseController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource

  def index

  end

  def show

  end

  def new
    @course = Course.new
  end

  def create

  end

  def edit

  end

  def update

  end

  def destroy

  end

end
