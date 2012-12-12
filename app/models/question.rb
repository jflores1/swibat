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
  attr_accessible :title, :text, :user, :answers

  belongs_to :user
  has_many :answers

  validates :title, :presence => true
  validates :text, :presence => true, :length => {:maximum => 4000} 

end
