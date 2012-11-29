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
  acts_as_commentable
  
  attr_accessible :expected_end_date, :expected_start_date, :prior_knowledge, :unit_status, :unit_title, :objectives_attributes, :assessments_attributes
  has_many :objectives, as: :objectiveable
  has_many :assessments, as: :assessable
  has_many :lessons
  belongs_to :course

  accepts_nested_attributes_for :objectives, :reject_if => lambda { |a| a[:objective].blank? }, allow_destroy: true
  accepts_nested_attributes_for :assessments, :reject_if => lambda { |a| a[:assessment_name].blank? }, allow_destroy: true

  before_save do |unit|
    unit.prior_knowledge = prior_knowledge.humanize
    unit.unit_status = unit_status.capitalize
    unit.unit_title = unit_title.titleize
  end

  VALID_STATUS = %w[Pending Started Complete]

  validate :valid_unit_status

  validates :expected_end_date, presence: true, date: {after: :expected_start_date}
  validates :expected_start_date, presence: true, date: {before: :expected_end_date}
  validates :unit_status, presence: true
  validates :unit_title, presence: true

  def valid_unit_status
    errors.add(:unit_status, "is not a valid status") unless VALID_STATUS.include? unit_status
  end

end
