# == Schema Information
#
# Table name: friendships
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  friend_id  :integer
#  status     :string(255)      default("pending"), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Friendship < ActiveRecord::Base

  belongs_to :user
  belongs_to :friend, :class_name => "User"

  attr_accessible :user, :friend, :status

  validates :user, :presence => true
  validates :friend, :presence => true
  validates :status, :presence => true
  validate :valid_status

  STATUSES = %w[pending requested accepted]

  # Create a friend fequest by user to friend
  def self.request(user, friend)
    unless user == friend or Friendship.exists?(user, friend)
      transaction do
        create(:user => user, :friend => friend, :status => 'pending')
        create(:user => friend, :friend => user, :status => 'requested')
      end
    end
  end

  # User accepts incoming friend request
  def accept(user)
    if self.status == 'requested' && self.user == user
      transaction do
        opposite = Friendship.find_by_user_id_and_friend_id(self.friend.id, self.user.id)
        self.status = 'accepted'        
        opposite.status = 'accepted'
        self.save!
        opposite.save!
      end
    end
  end

  # User declines a friend requests or unfriends a friend
  def remove(user)
    if self.user == user || self.friend == user
      transaction do
        opposite = Friendship.find_by_user_id_and_friend_id(self.friend.id, self.user.id)
        self.destroy
        opposite.destroy
      end
    end
  end

  def self.exists?(user, friend)
    Friendship.find_by_user_id_and_friend_id(user.id, friend.id) != nil
  end

  def requested_by?(user)
    (self.user == user && status == 'pending') || (self.friend == user && status == 'requested')
  end

  private

  def valid_status
    errors.add(:status, "is not a valid friendship status") unless STATUSES.include? status
  end

end