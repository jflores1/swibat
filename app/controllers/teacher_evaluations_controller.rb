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
      domain_hash = {name: domain.name, score: domain.calculate_score(@evaluation), criteria: []}      
      domain.evaluation_criteria.each do |criterion|
        domain_hash[:criteria] << {name: criterion.contents , score: EvaluationRating.find_by_criterion_id_and_evaluation_id(criterion.id, @evaluation.id).score, domain: domain.name}
      end
      @data << domain_hash
    end
    @json_data = @data.to_json
    

    # Data for the alternative view
    # @data = {}
    # @domains = []
    # @criteria = []
    # @evaluation.evaluation_template.evaluation_domains.each do |domain|
    #   domain_hash = {domain: domain.name}
    #   domain_hash[:criteria] = []
    #   domain.evaluation_criteria.each do |criterion|
    #     @criteria << {name: criterion.contents}
    #     domain_hash[:criteria] << {name: criterion.contents , score: EvaluationRating.find_by_criterion_id_and_evaluation_id(criterion.id, @evaluation.id).score}
    #   end

    #   @domains << domain_hash
    # end
    # @data[:domains] = @domains
    # @data[:criteria] = @criteria
    # @json_data = @data.to_json


  end

  def create
  	@evaluation = TeacherEvaluation.new(params[:teacher_evaluation])
    @evaluation.save!
      params[:score].each do |criterion_id, score|
        rating = EvaluationRating.find_or_create_by_criterion_id_and_evaluation_id(criterion_id, @evaluation.id)
        rating.score = score
        rating.save
      end

    redirect_to institution_evaluation_path(@institution, @evaluation)
  end

  def destroy
    @evaluation = TeacherEvaluation.find(params[:id])
    if @evaluation.destroy
      redirect_to :back, :notice => 'Observation was successfully deleted.'
    else
      redirect_to :back, :notice => 'There was an error while trying to delete the observation.'
    end
  end
  
  private
  	def load_institution
  		@institution = Institution.find(params[:institution_id])
  	end

end
