class Post < ActiveRecord::Base
  include PgSearch
  acts_as_taggable
  attr_accessible :content, :title, :tag_list
  belongs_to :user

  validates :content, :title, presence: true

  multisearchable :against => [:title, :content]

  def author
    self.user.full_name
  end

  def to_param
    "#{id}-#{self.title.strip.parameterize}"
  end

  def to_s
    self.title
  end

end
