class EvaluationsController < ApplicationController
  before_filter :load_institution

  
  def index
    @evaluations = @institution.evaluations
  end

  def show
  	@evaluation = TeacherEvaluation.find(params[:id])
  	@user = @evaluation.teacher
  end

  def create
  	@evaluation = TeacherEvaluation.new(params[:teacher_evaluation])
  	@evaluation.save
  	params[:score].each do |criterion_id, score|
  		rating = EvaluationRating.find_or_create_by_criterion_id_and_evaluation_id(criterion_id, @evaluation.id)
  		rating.score = score
  		rating.save
  	end

  	redirect_to institution_evaluation_path(@institution, @evaluation)
  end

  private
  	def load_institution
  		@institution = Institution.find(params[:institution_id])
  	end

end
