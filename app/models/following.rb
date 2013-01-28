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

  belongs_to :user
  belongs_to :followee, :class_name => "User"

  attr_accessible :user, :followee_id

  validates :user, :presence => true
  validates :followee, :presence => true


  # User follows someone
  def self.follow(user, followee)
    unless user == followee or Following.exists?(user, followee)
      create(:user => user, :followee => followee)
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

end
