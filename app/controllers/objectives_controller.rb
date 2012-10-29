class ObjectivesController < ApplicationController
  before_filter :load_objectiveable

  def index
    @objectives = @objectiveable.objectives
  end

  def new
  end

private

  def load_objectiveable
    klass = [Course, Unit, Lesson].detect {|o| params["#{o.name.underscore}_id"]}
    @objectiveable = klass.find(params["#{klass.name.underscore}_id"])
  end

end
