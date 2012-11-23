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

  def self.exists?(user, friend)
    Friendship.find_by_user_id_and_friend_id(user.id, friend.id) != nil
  end

  private

  def valid_status
    errors.add(:status, message:"Invalid friendship status: " + status) unless STATUSES.include? status
  end

end
