class EvaluationTemplatesController < ApplicationController
	before_filter :load_institution
  
  def index
  	@templates = @institution.evaluation_templates
  end

  def show
  	@template = @institution.evaluation_templates.find(params[:id])
  end

  def new
  	@template = @institution.evaluation_templates.create(name: "Evaluation Template " + (@institution.evaluation_templates.count + 1).to_s)
  	redirect_to [@institution, @template]
  end

  def new_prepopulated_template
  	@template = EvaluationTemplate.create_default_template_for(@institution, params[:base_template_id])
  	@institution.evaluation_templates << @template
  	@institution.save
  	redirect_to [@institution, @template]
  end

  def update
  	@template = @institution.evaluation_templates.find(params[:id])
  	@template.update_attributes(params[:evaluation_template])
  	redirect_to [@institution, @template], notice: "Template saved successfully"
  end

  def destroy
    @template = @institution.evaluation_templates.find(params[:id])
    @template.destroy
    redirect_to institution_evaluation_templates_path, notice: "Template deleted successfully"
  end

  def add

  end

  def choose
    @danielson = EvaluationTemplate.where(name: 'Danielson Framework').first
    @marzano = EvaluationTemplate.where(name: 'Marzano Framework').first
  end

  private
  	def load_institution
  		@institution = Institution.find(params[:institution_id])
  	end
end
