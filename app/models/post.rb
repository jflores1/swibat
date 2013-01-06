class Post < ActiveRecord::Base
  acts_as_taggable
  attr_accessible :content, :title, :tag_list
  belongs_to :user

  validates :content, :title, presence: true
end
