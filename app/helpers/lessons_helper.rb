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


  def display_educational_domain_children(domain)
    tree = content_tag :li do   
      concat domain.name + "(" + domain.id.to_s + ")"
      if domain.children.any?
        concat raw "<ul>"
        domain.children.each do |child|
          concat raw "#{display_educational_domain_children(child)}"
        end
        concat raw "</ul>"
      end
    end

    tree
  end

  def display_educational_domains_for_grade(grade)
    tree = ""  
    if grade.educational_domains.any?
      grade.educational_domains.each do |domain|
        tree += raw "#{display_educational_domain_children(domain)}"
      end
    end
    raw tree
  end

end
