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
    
    tree = content_tag :h3, domain.name
    if domain.children.any?

      tree += raw '<div><div class="accordion">'
      domain.children.each do |child|
        tree += raw "#{display_educational_domain_children(child)}"
      end
      tree += raw "</div></div>"
    else
      tree+= raw "<div>#{display_standards_for_domain(domain)}</div>"
    end

    tree
  end

  def display_educational_domains_for_grade(grade)
    tree = ""  
    if grade.educational_domains.any?
      tree += content_tag :div, class: "accordion" do   
        grade.educational_domains.each do |domain|          
            concat raw "#{display_educational_domain_children(domain)}"          
        end
      end
    end
    raw tree
  end

  def display_standards_for_domain(domain)
    content = raw "<ul>"
    domain.standard_strands.each do |strand|
      strand.educational_standards.each do |standard|
        next if standard.parent != nil
        content += raw "<li class=\"draggable\" data-id=\"#{standard.id.to_s}\">#{standard.name}</li>"
      end
    end

    content += raw "</ul>"
    content
  end

end
