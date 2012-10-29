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
#

class Course < ActiveRecord::Base
  attr_accessible :course_name, :course_semester, :course_summary, :course_year
  has_many :objectives, as: :objectiveable
  has_many :assessments, as: :assessable
  has_many :units
  has_and_belongs_to_many :subjects

  before_save do |course|
    course.course_name = course_name.titleize
    course.course_semester = course_semester.capitalize
    course.course_summary = course_summary.humanize
  end

  VALID_SEMESTER = %w[Fall Spring Summer Winter]

  validates :course_name, presence: true
  validates :course_semester, presence: true
  validates :course_year, presence:true, length:{is:4}
  validate :has_valid_semester

  def has_valid_semester
    errors.add(:course_semester, message: "Sorry, that's not a valid semester") unless VALID_SEMESTER.include? course_semester
  end
end
