module UnitsHelper

  def unit_content(unit)
    if unit.content_taught.count == 0
      content_tag :p, "No content objectives have been added yet."
    else
      content_tag :ul, class:"content-list" do
        render partial: 'objectives/objective', collection: unit.objectives.content
      end
    end
  end

  def unit_skills(unit)
    if unit.skills_taught.count == 0
      content_tag :p, "No skill objectives have been added yet."
    else
      content_tag :ul, class:"skill-list" do
        render partial: 'objectives/objective', collection: unit.objectives.skills
      end
    end
  end

  def unit_assessments(unit)
    if unit.assessments.count == 0
      content_tag :p, "No assessments have been added yet."
    else
      content_tag :ul, class:"assessment-list" do
        render partial: 'assessments/assessment', collection: unit.assessments
      end
    end
  end

  def unit_lessons(unit)
    if unit.lessons.count == 0
      content_tag :p, "No lessons have been added yet"
    else
      content_tag :ul do
        unit.lessons.collect do |lesson|
          content_tag :li do
            concat(link_to lesson.lesson_title, unit_lesson_path(unit, lesson))
          end.to_s
        end.join().html_safe
      end
    end
  end

end
