class Post < ActiveRecord::Base
  include PgSearch
  acts_as_taggable
  attr_accessible :content, :title, :tag_list
  belongs_to :user

  validates :content, :title, presence: true

  def author
    self.user.full_name
  end

  def to_param
    "#{id}-#{self.title.strip.parameterize}"
  end

  multisearchable :against => [:title, :content]

end
