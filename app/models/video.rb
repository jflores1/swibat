# == Schema Information
#
# Table name: videos
#
#  id          :integer          not null, primary key
#  title       :string(255)
#  description :text
#  yt_video_id :string(255)
#  is_complete :boolean          default(FALSE)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  lesson_id   :integer
#  user_id     :integer
#  uploader_id :integer
#

class Video < ActiveRecord::Base

  acts_as_commentable
  acts_as_taggable
  
  attr_accessible :yt_video_id, :description, :title, :is_complete, :user_id, :lesson_id, :tag_list

  belongs_to :lesson
  belongs_to :user
  belongs_to :uploader, class_name: "User"

  scope :completes,   where(:is_complete => true)
  scope :incompletes, where(:is_complete => false)

  validates :title, presence: true

  def self.yt_session
    @yt_session ||= YouTubeIt::Client.new(:username => YouTubeITConfig.username , :password => YouTubeITConfig.password , :dev_key => YouTubeITConfig.dev_key)    
  end

  def self.delete_video(video)
    yt_session.video_delete(video.yt_video_id)
    video.destroy
      rescue
        video.destroy
  end

  def self.update_video(video, params)
    yt_session.video_update(video.yt_video_id, video_options(params))
    video.update_attributes(params)
  end

  def self.token_form(params, nexturl)    
    yt_session.upload_token(video_options(params), nexturl)
  end

  def self.delete_incomplete_videos
    self.incompletes.map{|r| r.destroy}
  end

  private
    def self.video_options(params)
      opts = {:title => params[:title],
             :description => params[:description],
             :category => "Education",
             :keywords => []}
      params[:is_unpublished] == "1" ? opts.merge(:unlisted => "true") : opts
    end

end
