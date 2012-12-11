class Question < ActiveRecord::Base
  attr_accessible :title, :text, :user, :answers

  belongs_to :user
  has_many :answers

  validates :title, :presence => true
  validates :text, :presence => true, :length => {:maximum => 4000} 

end
