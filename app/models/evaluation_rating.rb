# == Schema Information
#
# Table name: evaluation_ratings
#
#  id            :integer          not null, primary key
#  evaluation_id :integer
#  criterion_id  :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  score         :integer
#

class EvaluationRating < ActiveRecord::Base
  attr_accessible :criterion_id, :evaluation_id, :criterion, :evaluation
  belongs_to :criterion, class_name: :EvaluationCriterion
  belongs_to :evaluation, class_name: :TeacherEvaluation


end
