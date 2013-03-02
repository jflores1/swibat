class VideosController < ApplicationController

  load_and_authorize_resource :except => [:save_video]
  
	def index
		@videos = Video.all
	end

	def show
		@video = Video.find(params[:id])
    @user = @video.user
	end

	def new    
		@video = Video.new
    @video.user = User.find(params[:user_id]) if params[:user_id]
    @video.lesson = Lesson.find(params[:lesson_id]) if params[:lesson_id]
	end

	def edit
		@video = Video.find(params[:id])
	end

	def upload
    @video = Video.new(params[:video])    
    @video.uploader = current_user
    if @video.save
      @upload_info = Video.token_form(params[:video], save_video_new_video_url(:video_id => @video.id))
    else
      respond_to do |format|
        format.html { render "/videos/new" }
      end
    end
  end

  def update
    @video     = Video.find(params[:id])
    @result    = Video.update_video(@video, params[:video])
    respond_to do |format|
      format.html do
        if @result
          redirect_to @video, :notice => "video successfully updated"
        else
          respond_to do |format|
            format.html { render "/videos/_edit" }
          end
        end
      end
    end
  end

  def save_video
    @id = params[:video_id]
    @yt_video_id = params[:id]


    @video = Video.find(@id)
    if params[:status].to_i == 200
      @video.update_attributes(:yt_video_id => @yt_video_id.to_s, :is_complete => true)
      Video.delete_incomplete_videos
    else
      Video.delete_video(@video)
    end
    redirect_to @video, :notice => "video successfully uploaded"
  end

  def destroy
    @video = Video.find(params[:id])
    if Video.delete_video(@video)
      flash[:notice] = "video successfully deleted"
    else
      flash[:error] = "video unsuccessfully deleted"
    end
    redirect_to videos_path
  end

  protected
    def collection
      @videos ||= end_of_association_chain.completes
    end
end
