# == Schema Information
#
# Table name: lesson_activities
#
#  id         :integer          not null, primary key
#  activity   :string(255)
#  duration   :string(255)
#  agent      :string(255)
#  lesson_id  :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class LessonActivity < ActiveRecord::Base
  attr_accessible :activity, :duration, :agent
  belongs_to :lesson

  VALID_AGENT = ["Teacher", "Student", "Group", "Class"]

  validate :valid_agent
  validates :activity, presence: true

  def valid_agent
    errors.add(:agent, "is not a valid actor") unless VALID_AGENT.include? agent
  end

  def user
    self.lesson.user
  end
end
