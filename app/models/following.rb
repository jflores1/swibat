# == Schema Information
#
# Table name: followings
#
#  id          :integer          not null, primary key
#  user_id     :integer
#  followee_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Following < ActiveRecord::Base

  include PublicActivity::Common

  belongs_to :user
  belongs_to :followee, :class_name => "User"

  attr_accessible :user, :followee_id, :user_id, :followee

  validates :user, :presence => true
  validates :followee, :presence => true

  after_create :being_followed_notification


  # User follows someone
  def self.follow(user, followee)
    unless user == followee or Following.exists?(user, followee)
      following = Following.new(:user => user, :followee => followee)
      following.save      
    end
  end

  # User unfollows someone
  def self.unfollow(user, followee)
    following = Following.find_by_user_id_and_followee_id(user.id, followee.id)
    if following != nil
      following.destroy
    end
  end

  def self.exists?(user, followee)
    Following.find_by_user_id_and_followee_id(user.id, followee.id) != nil
  end

  private
  def being_followed_notification
    FollowingMailer.being_followed(self.user, self.followee)
  end

end
