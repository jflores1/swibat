class Micropost < ActiveRecord::Base
  attr_accessible :content
  belongs_to :user

  validates :content, presence: true
  validates :content, length: {maximum: 140}

  default_scope order('created_at desc')
end
