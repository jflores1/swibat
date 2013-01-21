module LessonsHelper
  def list_assessments(lesson)
    if lesson.assessments.count == 0
      content_tag :p, "No assessments have been added yet."
    else
      content_tag :ul do
        lesson.assessments.collect do |lesson_assessment|
          concat(content_tag :li, lesson_assessment.assessment_name )
        end
      end
    end
  end
end
