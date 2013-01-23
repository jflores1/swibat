module LessonsHelper


  def lesson_content(lesson)
    if lesson.content_taught.count == 0
      content_tag :p, "No content objectives have been added yet."
    else
      content_tag :ul do
        lesson.content_taught.collect do |objective|
          concat(content_tag :li, objective.objective)
        end
      end
    end
  end

  def lesson_skills(lesson)
    if lesson.skills_taught.count == 0
      content_tag :p, "No skill objectives have been added yet."
    else
      content_tag :ul do
        lesson.skills_taught.collect do |objective|
          concat(content_tag :li, objective.objective)
        end
      end
    end
  end

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
