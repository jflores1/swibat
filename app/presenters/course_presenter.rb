class CoursePresenter < BasePresenter
  presents :course

  def course_name
    course.course_name
  end

end