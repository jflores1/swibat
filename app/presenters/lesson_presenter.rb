class LessonPresenter < BasePresenter
  presents :lesson
  delegate :lesson_title, to: :lesson

  def prior_knowledge
    handle_none(lesson.prior_knowledge) do
      lesson.prior_knowledge
    end
  end

  def lesson_objectives
    handle_none(lesson.objectives) do
      h.content_tag :ul do
        lesson.objectives.collect do |lesson_objective|
          h.concat(h.content_tag :li, lesson_objective.objective)
        end
      end
    end
  end

  def lesson_assessments
    handle_none(lesson.assessments) do
      h.content_tag :ul do
        lesson.assessments.collect do |lesson_assessment|
          h.concat(h.content_tag :li, lesson_assessment.assessment_name)
        end
      end
    end
  end

  def lesson_resources
    handle_none(lesson.resources) do
      h.content_tag :ul do
        lesson.resources.collect do |lesson_resource|
          h.concat(h.content_tag :li, lesson_resource.name)
        end
      end
    end
  end

  def lesson_activity_row
    handle_none(lesson.lesson_activities) do
      lesson.lesson_activities.collect do |lesson_activity|
        h.content_tag :tr do
          h.concat(h.content_tag :td, "#{lesson_activity.activity}")
          h.concat(h.content_tag :td, "#{lesson_activity.duration}")
          h.concat(h.content_tag :td, "#{lesson_activity.agent}")
        end.to_s
      end.join().html_safe
    end
  end


end