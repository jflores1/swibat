class CoursePresenter < BasePresenter
  presents :course
  delegate :course_name, :taught_during, to: :course

  def full_name
    course.user.first_name + " " + course.user.last_name
  end

  def grade_level
    handle_none(course.grade.grade_level) do
      course.grade.grade_level
    end
  end

  def course_summary
    handle_none(course.course_summary) do
      course.course_summary
    end
  end

  def course_objectives
    handle_none(course.objectives) do
      h.content_tag :ul do
        course.objectives.collect do |course_objective|
          h.concat(h.content_tag :li, course_objective.objective)
        end
      end
    end
  end

  def tags
    handle_none(course.tag_list) do
      h.content_tag :p do
        h.raw course.tag_list.map {|t| h.link_to t, h.tag_courses_path(t), class:"tag_link"}.join(" ")
      end
    end
  end

  def units
    @units ||= course.units
  end


end