class AssessmentsController < ApplicationController
	before_filter :load_assessable
	respond_to :html, :js

	def new
		@assessment = @assessable.assessments.build
	end

	def create
		@assessment = @assessable.assessments.build(params[:assessment])
		@assessment.save!
		respond_with @assessment
	end

	def destroy
		@assessment = @assessable.assessments.find(params[:id])
		@assessment.destroy
	end

	private
	def load_assessable
		klass = [Course, Unit, Lesson].detect {|o| params["#{o.name.underscore}_id"]}
    	@assessable = klass.find(params["#{klass.name.underscore}_id"])
	end

end
