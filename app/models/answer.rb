class Answer < ActiveRecord::Base
  attr_accessible :question, :text, :user
  belongs_to :user
  belongs_to :question

  validates :text, :presence => true, :length => {:maximum => 4000} 
end
