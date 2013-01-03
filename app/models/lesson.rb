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
  include PgSearch

  acts_as_commentable

  attr_accessible :lesson_end_date, :lesson_start_date, :lesson_status, :lesson_title, :prior_knowledge, :resources_attributes, :objectives_attributes, :assessments_attributes
  has_many :objectives, as: :objectiveable
  has_many :assessments, as: :assessable
  has_many :resources
  has_many :activities
  belongs_to :unit
  has_many :flags, :as => :flaggable, :dependent => :destroy

  accepts_nested_attributes_for :resources, :reject_if => lambda { |a| a[:name].blank? }, :allow_destroy => true
  accepts_nested_attributes_for :objectives, :reject_if => lambda { |a| a[:objective].blank? }, allow_destroy: true
  accepts_nested_attributes_for :assessments, :reject_if => lambda { |a| a[:assessment_name].blank? }, allow_destroy: true
  accepts_nested_attributes_for :activities, :reject_if => lambda { |a| a[:activity].blank? }, allow_destroy: true

  has_reputation :votes, source: :user, aggregated_by: :sum

  before_save do |lesson|
    lesson.lesson_title = lesson_title.titleize
  end
  
  VALID_STATUS = ["Not Yet Started", "Started", "Complete"]

  validate  :valid_lesson_status

  validates :lesson_title, presence: true
  validates :lesson_start_date, presence: true, date: {before: :lesson_end_date}
  validates :lesson_end_date, presence: true, date: {after: :lesson_start_date}
  validates :lesson_status, presence: true

  multisearchable :against => [:lesson_title]

  def valid_lesson_status
    errors.add(:lesson_status, "is not a valid status") unless VALID_STATUS.include? lesson_status
  end

  def user
    self.unit.user
  end

  def to_param
    "#{id}-#{self.lesson_title.strip.parameterize}"
  end

  def to_s
    self.lesson_title
  end
end
