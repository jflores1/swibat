class PostsController < ApplicationController
	before_filter :authenticate_user!, except: [:show, :index]
	load_and_authorize_resource
  skip_authorize_resource only: [:show, :index]

	def index
		if params[:tag]
			@posts = Post.tagged_with(params[:tag])
		else
			@posts = Post.order('created_at desc').all
		end
  end

  def show
    @post = Post.find(params[:id])
  end

	def new
		@post = Post.new
	end

	def create
		@post = current_user.posts.build(params[:post])
		if @post.save!
			flash[:notice] = "New Post Saved!"
			redirect_to posts_path
		else
			flash[:error] = "There was an error with the post"
			render 'new'
		end
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    @post = Post.find(params[:id])
    if @post.update_attributes(params[:post])
      flash[:notice] = "Post updated!"
      redirect_to posts_path
    else
      flash[:error]="Sorry, the post didn't update properly!"
      render 'edit'
    end
  end

end
