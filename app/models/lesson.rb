# == Schema Information
#
# Table name: lessons
#
#  id                :integer          not null, primary key
#  lesson_title      :string(255)
#  lesson_start_date :date
#  lesson_end_date   :date
#  lesson_status     :string(255)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  unit_id           :integer
#  prior_knowledge   :string(255)
#

class Lesson < ActiveRecord::Base
  acts_as_commentable

  attr_accessible :lesson_end_date, :lesson_start_date, :lesson_status, :lesson_title, :prior_knowledge, :resources_attributes, :objectives_attributes, :assessments_attributes
  has_many :objectives, as: :objectiveable
  has_many :assessments, as: :assessable
  has_many :resources
  belongs_to :unit

  accepts_nested_attributes_for :resources, :reject_if => lambda { |a| a[:name].blank? }, :allow_destroy => true
  accepts_nested_attributes_for :objectives, :reject_if => lambda { |a| a[:objective].blank? }, allow_destroy: true
  accepts_nested_attributes_for :assessments, :reject_if => lambda { |a| a[:assessment_name].blank? }, allow_destroy: true


  VALID_STATUS = %w[Pending Started Complete]

  validate  :valid_lesson_status

  validates :lesson_title, presence: true
  validates :lesson_start_date, presence: true, date: {before: :lesson_end_date}
  validates :lesson_end_date, presence: true, date: {after: :lesson_start_date}
  validates :lesson_status, presence: true




  def valid_lesson_status
    errors.add(:lesson_status, message:"Sorry, that's not a valid status") unless VALID_STATUS.include? lesson_status
  end
end
