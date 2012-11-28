class ObjectivesController < ApplicationController
  before_filter :load_objectiveable

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

private

  def load_objectiveable
    klass = [Course, Unit, Lesson].detect {|o| params["#{o.name.underscore}_id"]}
    @objectiveable = klass.find(params["#{klass.name.underscore}_id"])
  end

end
