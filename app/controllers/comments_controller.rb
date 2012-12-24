class CommentsController < ApplicationController
  load_and_authorize_resource

  before_filter :authenticate_user!
  before_filter :get_commentable, :only => [:create]

  def create
  	@comment = Comment.build_from(@commentable, current_user.id, params[:comment][:body])

    respond_to do |format|
      if @comment.save
        format.html { redirect_to(:back, :notice => 'Comment was successfully created.') }        
      else
        format.html { render @commentable }        
      end
    end
  end

  def destroy
  	@comment = Comment.find(params[:id])
  	respond_to do |format|
	  	if @comment.destroy  		
	  		format.html { redirect_to(:back, :notice => 'Comment was successfully deleted.') }        
	  	else
	  		format.html { redirect_to(:back, :notice => 'There was an error while trying to delete the comment.') }        
	  	end
  	end
  end

  private
  
    def get_commentable
      @commentable = Comment.find_commentable(params[:comment][:commentable_type], (params[:comment][:commentable_id]))
  	end
end
