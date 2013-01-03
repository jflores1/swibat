# == Schema Information
#
# Table name: answers
#
#  id          :integer          not null, primary key
#  text        :text
#  question_id :integer
#  user_id     :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Answer < ActiveRecord::Base
	include PgSearch

  attr_accessible :question, :text, :user
  belongs_to :user
  belongs_to :question
  has_many :flags, :as => :flaggable, :dependent => :destroy

  validates :text, :presence => true, :length => {:maximum => 4000} 

  has_reputation :votes, source: :user, aggregated_by: :sum

  multisearchable :against => [:text]

  def to_s
  	self.text
  end
  
end
