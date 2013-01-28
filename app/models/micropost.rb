# == Schema Information
#
# Table name: microposts
#
#  id         :integer          not null, primary key
#  content    :string(255)
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Micropost < ActiveRecord::Base
  attr_accessible :content
  belongs_to :user

  validates :content, presence: true
  validates :content, length: {maximum: 140}

  default_scope order('created_at desc')

  def self.from_users_followed_by(user)
  	followed_user_ids = user.people_followed_ids
  	where('user_id IN (?) OR user_id = ?', followed_user_ids, user)
  end
end
