class CourseController < ApplicationController
  before_filter :authenticate_user!, except: [:index]
end
