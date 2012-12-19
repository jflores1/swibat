# == Schema Information
#
# Table name: activities
#
#  id         :integer          not null, primary key
#  activity   :string(255)
#  duration   :string(255)
#  agent      :string(255)
#  lesson_id  :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Activity < ActiveRecord::Base
  attr_accessible :activity, :duration, :agent
  belongs_to :lesson

  VALID_AGENT = ["Teacher", "Student", "Class"]

  validate :valid_agent
  validates :activity, presence: true

  def valid_agent
    errors.add(:agent, "is not a valid actor") unless VALID_AGENT.include? agent
  end
end
