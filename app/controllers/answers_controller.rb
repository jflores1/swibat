class AnswersController < ApplicationController

	before_filter :authenticate_user!
  before_filter :find_current_question, :except => [:vote]
  load_and_authorize_resource

  def new
  	@answer = @question.answers.build
  end

  def create
		@answer = @question.answers.build(params[:answer])
		@answer.user = current_user
    if @answer.save 
      redirect_to @question, :notice => 'Answer was successfully created.'
    else      
      render action: 'new'
    end
  end

  def edit
  	@answer = Answer.find(params[:id])
  end

  def update
    @answer = Answer.find(params[:id])
    if @answer.update_attributes(params[:answer])
      redirect_to @question, :notice => 'Answer was successfully updated.'
    else
      render action: "edit"
    end
  end

  def destroy
    @answer = Answer.find(params[:id])
    @answer.destroy
    redirect_to @question, :notice => 'Answer was successfully deleted.'
  end

  def vote
    @answer = Answer.find(params[:id])
    if params[:type] == 'clear'
      @answer.delete_evaluation(:votes, current_user)
    else
      value = params[:type] == "up" ? 1 : -1      
      @answer.add_or_update_evaluation(:votes, value, current_user)
    end
    redirect_to :back, notice: "Thank you for voting"
  end

  private

    def find_current_question
    	@question = Question.find(params[:question_id])
    end
end
