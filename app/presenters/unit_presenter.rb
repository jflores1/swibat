class UnitPresenter < BasePresenter
  presents :unit
  delegate :unit_title, to: :unit

  def prior_knowledge
    handle_none(unit.prior_knowledge) do
      unit.prior_knowledge
    end
  end

  def unit_objectives
    handle_none(unit.objectives) do
      h.content_tag :ul do
        unit.objectives.collect do |unit_objective|
          h.concat(h.content_tag :li, unit_objective.objective)
        end
      end
    end
  end

  def unit_assessments
    handle_none(unit.assessments) do
      h.content_tag :ul do
        unit.assessments.collect do |unit_assessment|
          h.concat(h.content_tag :li, unit_assessment.assessment_name)
        end
      end
    end
  end

  def lessons
    @lessons ||= unit.lessons
  end


end