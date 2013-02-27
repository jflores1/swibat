module LessonsHelper


  def lesson_content(lesson)
    if lesson.content_taught.count == 0
      content_tag :p, "No content objectives have been added yet."
    else
      content_tag :ul, class:"content-list" do
        render partial: 'objectives/objective', collection: lesson.objectives.content
      end
    end
  end

  def lesson_skills(lesson)
    if lesson.skills_taught.count == 0
      content_tag :p, "No skill objectives have been added yet."
    else
      content_tag :ul, class:"skill-list" do
        render partial: 'objectives/objective', collection: lesson.objectives.skills
      end
    end
  end

  def list_assessments(lesson)
    if lesson.assessments.count == 0
      content_tag :p, "No assessments have been added yet."
    else
      content_tag :ul, class:"assessment-list" do
        render partial: 'assessments/assessment', collection: lesson.assessments
      end
    end
  end


  def display_educational_domain_children(domain)    
    tree = content_tag :h3, domain.name
    if domain.children.any?
      tree += raw '<div><div class="corestandards-accordion">'
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
      tree += content_tag :div, class: "corestandards-accordion" do   
        grade.educational_domains.each do |domain|          
          # skip if they are not root domains
          next if ![1,69].include?(domain.parent_id )
            concat raw "#{display_educational_domain_children(domain)}"          
        end
      end
    end
    raw tree
  end

  def display_standards_for_domain(domain)
    content = raw "<ul class=\"standards-list\">"
    domain.standard_strands.each do |strand|
      strand.educational_standards.each do |standard|
        next if standard.parent != nil
        content += raw "<li data-content=\"#{standard.description}\" title=\"#{standard.name}\" class=\"draggable list-description\" data-id=\"#{standard.id.to_s}\">#{standard.description}</li>"
      end
    end

    content += raw "</ul>"
    content
  end

  def display_standards_for_lesson(lesson, add_remove_button = false)
    content = raw "<ul class=\"standards-ul\">"
    lesson.educational_standards.each do |standard|      
      content += raw generate_standard_list_item(standard, add_remove_button, lesson)
    end
    content += raw "</ul>"
    content
  end

  def generate_standard_list_item(standard, add_remove_button, lesson)
    result = "<li class=\"standard-item\" id=\"standard-#{standard.id}\" data-content=\"#{standard.description}\" title=\"#{standard.name}\" data-id=\"#{standard.id.to_s}\">#{standard.name}"
    result += link_to "<i title=\"Remove this standard\" class=\"icon-trash pull-right\"></i>".html_safe, remove_standard_lesson_path(lesson, standard_id: standard.id), method: :post, remote:true if add_remove_button
    result += "</li>"
    raw result
  end

  def display_standards_for_unit(unit)
    tree = raw "" 
    if unit.lessons.any?      
      tree += content_tag :div, class: "corestandards-accordion" do   
        unit.lessons.each do |lesson|  
            concat raw "<h3>#{lesson.lesson_title}</h3>"        
            concat raw "#{display_standards_for_lesson(lesson)}"                      
        end  
      end    
    end
    raw tree
  end
  


end
