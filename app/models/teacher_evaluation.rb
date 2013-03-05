# == Schema Information
#
# Table name: teacher_evaluations
#
#  id                     :integer          not null, primary key
#  teacher_id             :integer
#  evaluation_template_id :integer
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#

class TeacherEvaluation < ActiveRecord::Base
  attr_accessible :evaluation_template_id, :teacher_id, :eval_type

  belongs_to :teacher, class_name: :User
  belongs_to :evaluation_template
  has_many :evaluation_ratings, foreign_key: :evaluation_id, dependent: :destroy
  has_one :video, foreign_key: :observation_id

  accepts_nested_attributes_for :evaluation_ratings
end
