# == Schema Information
#
# Table name: units
#
#  id                  :integer          not null, primary key
#  unit_title          :string(255)
#  expected_start_date :date
#  expected_end_date   :date
#  prior_knowledge     :string(255)
#  unit_status         :string(255)
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  course_id           :integer
#

class Unit < ActiveRecord::Base
  include PgSearch

  acts_as_commentable
  
  attr_accessible :expected_end_date, :expected_start_date, :prior_knowledge, :unit_status, :unit_title, :objectives_attributes, :assessments_attributes
  has_many :objectives, as: :objectiveable, dependent: :destroy
  has_many :assessments, as: :assessable, dependent: :destroy
  has_many :lessons, dependent: :destroy
  belongs_to :course
  has_many :flags, :as => :flaggable, dependent: :destroy

  accepts_nested_attributes_for :objectives, :reject_if => lambda { |a| a[:objective].blank? }, allow_destroy: true
  accepts_nested_attributes_for :assessments, :reject_if => lambda { |a| a[:assessment_name].blank? }, allow_destroy: true

  has_reputation :votes, source: :user, aggregated_by: :sum
  
  before_save do |unit|
    unit.prior_knowledge = prior_knowledge.humanize
    unit.unit_title = unit_title.titleize
  end

  VALID_STATUS = ["Pending", "Started", "Complete"]

  #validate :valid_unit_status

  validates :expected_end_date, presence: true, date: {after: :expected_start_date}
  validates :expected_start_date, presence: true, date: {before: :expected_end_date}
  validates :unit_status, length:{maximum: 50}, allow_blank: true
  validates :unit_title, presence: true

  multisearchable :against => [:unit_title]

  def user
    self.course.user
  end

  def valid_unit_status
    errors.add(:unit_status, "is not a valid status") unless VALID_STATUS.include? unit_status
  end

  def to_param
    "#{id}-#{self.unit_title.parameterize}"
  end

  def to_s
    self.unit_title
  end

  amoeba do 
    exclude_field [:flags, :comment_threads, :evaluations, :reputations]
  end
end
