class ObjectivesController < ApplicationController
  before_filter :load_objectiveable, :except => [:similar_objectiveables]

  def index
    @objectives = @objectiveable.objectives
  end

  def new
    @objective = @objectiveable.objectives.new
  end

  def create
    @objective = @objectiveable.objectives.new(params[:objective])
    if @objective.save
      #
    else
      #
    end

  end

  def similar_objectiveables
    objectives = JSON.parse(params[:objectives])
    type = params[:type]
    @related_objectiveables = Objective.find_similar_objectiveables(objectives, type)    
    # inject polymorphic urls
    @related_objectiveables.map {|obj| obj[:url] = generate_path(obj[:objectiveable])}
    
    render json: @related_objectiveables      
  end

private

  def load_objectiveable
    klass = [Course, Unit, Lesson].detect {|o| params["#{o.name.underscore}_id"]}
    @objectiveable = klass.find(params["#{klass.name.underscore}_id"])
  end

  # Generate the path to the objective to be rendered in the javascript callback
  def generate_path objectiveable
    path = ''
    if objectiveable.class.to_s == "Lesson"
      path = unit_lesson_path objectiveable.unit, objectiveable
    elsif objectiveable.class.to_s == "Unit"

    elsif objectiveable.class.to_s == "Course"

    end
    path
  end

end
