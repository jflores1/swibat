# == Schema Information
#
# Table name: courses
#
#  id              :integer          not null, primary key
#  course_name     :string(255)
#  course_semester :string(255)
#  course_year     :integer
#  course_summary  :text
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  user_id         :integer
#  grade_id        :integer
#

class Course < ActiveRecord::Base
  acts_as_commentable
  
  attr_accessible :course_name, :course_semester, :course_summary, :course_year, :grade, :grade_id, :objectives_attributes

  has_many :objectives, as: :objectiveable
  has_many :units
  has_and_belongs_to_many :subjects
  belongs_to :user
  belongs_to :grade
  has_many :flags, :as => :flaggable, :dependent => :destroy

  accepts_nested_attributes_for :objectives, :reject_if => lambda { |a| a[:objective].blank? }, allow_destroy: true

  has_reputation :votes, source: :user, aggregated_by: :sum

  before_save do |course|
    course.course_name = course_name.titleize
    course.course_semester = course_semester.capitalize
    course.course_summary = course_summary.humanize
  end

  VALID_SEMESTER = %w[Fall Spring Summer Winter]

  validates :course_name, presence: true
  validates :course_semester, :grade_id, presence: true
  validates :course_year, presence:true, length:{is:4}
  validate :has_valid_semester

  def has_valid_semester
    errors.add(:course_semester, "is not a valid semester") unless VALID_SEMESTER.include? course_semester
  end

  def to_s
    self.course_name
  end
end
