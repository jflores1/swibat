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
    based_on = params[:based_on]
    objectives = JSON.parse(params[:objectives])    
    type = params[:type]

    related_objectiveables = Objective.find_similar_objectiveables(objectives, type, based_on)    

    # inject polymorphic urls
    related_objectiveables.map do |obj|
      obj[:url] = generate_path(obj[:objectiveable])
      obj[:link_title] = obj[:objectiveable].to_s
    end
    @result = {:objectiveables => related_objectiveables, :based_on => based_on}
    
    render json: @result      
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
      path = course_unit_path objectiveable.course, objectiveable
    elsif objectiveable.class.to_s == "Course"
      path = course_path objectiveable
    end
    path
  end

end
