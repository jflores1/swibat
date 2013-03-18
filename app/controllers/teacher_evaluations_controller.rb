class TeacherEvaluationsController < ApplicationController
  before_filter :load_institution, :authenticate_user!
  load_and_authorize_resource :class => "TeacherEvaluation"

  
  def index
    @evaluations = @institution.evaluations    
  end

  def show
  	@evaluation = TeacherEvaluation.find(params[:id])
  	@user = @evaluation.teacher


    @data = []
    @evaluation.evaluation_template.evaluation_domains.each do |domain|
      @data << {name: domain.name , score: domain.calculate_score(@evaluation).to_f}
    end
    @json_data = @data.to_json
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
