# == Schema Information
#
# Table name: questions
#
#  id         :integer          not null, primary key
#  title      :string(255)
#  text       :text
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Question < ActiveRecord::Base
  include PgSearch

  attr_accessible :title, :text, :user, :answers, :tag_list
  acts_as_taggable

  belongs_to :user
  has_many :answers
  has_many :flags, :as => :flaggable, :dependent => :destroy

  before_save do |question|
    question.title = title.titleize
  end

  validates :title, :presence => true
  validates :text, :presence => true, :length => {:maximum => 4000} 

  has_reputation :votes, source: :user, aggregated_by: :sum

  scope :recent, order('created_at desc')
  scope :sidebar, recent.limit(10)

  multisearchable against: [:title, :text]

  def to_param
    "#{id}-#{self.title.strip.parameterize}"
  end

  def to_s
    self.title
  end

end
