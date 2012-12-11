class QuestionsController < ApplicationController

	before_filter :authenticate_user!
  load_and_authorize_resource

  def index
  	@questions = Question.all
  end

  def show
    @question = Question.find(params[:id])
  end

  def new
    @question = Question.new    
  end

  def create
    @question = current_user.questions.build(params[:question])
    if @question.save 
      redirect_to @question, :notice => 'Question was successfully created.'
    else      
      render action: 'new'
    end
  end

  def edit
    @question = Question.find(params[:id])    
  end

  def update
    @question = Question.find(params[:id])
    if @question.update_attributes(params[:question])
      redirect_to @question, :notice => 'Question was successfully updated.'
    else
      render action: "edit"
    end
  end

  def destroy
    @question = Question.find(params[:id])
    @question.destroy
    redirect_to questions_path
  end

end
