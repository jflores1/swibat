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
  attr_accessible :question, :text, :user
  belongs_to :user
  belongs_to :question
  has_many :flags, :as => :flaggable, :dependent => :destroy

  validates :text, :presence => true, :length => {:maximum => 4000} 

  has_reputation :votes, source: :user, aggregated_by: :sum
end
