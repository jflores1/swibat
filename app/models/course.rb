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
  include PgSearch

  acts_as_commentable
  acts_as_taggable
  
  attr_accessible :course_name, :course_semester, :course_summary, :course_year, :grade, :grade_id, :objectives_attributes, :tag_list

  has_many :objectives, as: :objectiveable, dependent: :destroy
  has_many :units, dependent: :destroy
  belongs_to :user
  belongs_to :grade
  has_many :flags, :as => :flaggable, dependent: :destroy

  accepts_nested_attributes_for :objectives, :reject_if => lambda { |a| a[:objective].blank? }, allow_destroy: true

  has_reputation :votes, source: :user, aggregated_by: :sum

  before_save do |course|
    course.course_semester = course_semester.capitalize
    course.course_summary = course_summary.humanize
  end

  VALID_SEMESTER = %w[Fall Spring Summer Winter]

  validates :course_name, presence: true
  validates :course_semester, :grade_id, presence: true
  validates :course_year, presence:true, length:{is:4}
  validate :has_valid_semester

  #scopes
  scope :recent, order('created_at desc')
  scope :feed_sort, lambda { order('updated_at desc')}

  multisearchable :against => [:course_name, :course_summary]
  
  def has_valid_semester
    errors.add(:course_semester, "is not a valid semester") unless VALID_SEMESTER.include? course_semester
  end

  def taught_during
    self.course_semester + " " + self.course_year.to_s
  end

  def to_param
    "#{id}-#{self.course_name.strip.parameterize}"
  end

  def to_s
    self.course_name
  end

  # duplication rules
  amoeba do 
    exclude_field [:flags, :comment_threads, :evaluations, :reputations]
  end

  def duplicate_for user
    new_course = self.amoeba_dup
    new_course.user = user
    new_course.save

    new_course
  end
end
