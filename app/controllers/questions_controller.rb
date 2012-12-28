class QuestionsController < ApplicationController
	before_filter :authenticate_user!, except: [:index, :show]
  load_and_authorize_resource
  skip_authorize_resource only: [:index, :show]

  def index
    if params[:tag]
      @questions = Question.recent.tagged_with(params[:tag])
    else
      @questions = Question.recent
    end
  end

  def show
    @question = Question.find(params[:id])
    @user = @question.user
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

  def vote
    @question = Question.find(params[:id])
    if params[:type] == 'clear'
      @question.delete_evaluation(:votes, current_user)
    else
      value = params[:type] == "up" ? 1 : -1      
      @question.add_or_update_evaluation(:votes, value, current_user)
    end
    redirect_to :back, notice: "Thank you for voting"
  end

end
