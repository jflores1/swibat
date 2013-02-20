class EvaluationRating < ActiveRecord::Base
  attr_accessible :criterion_id, :evaluation_id, :criterion, :evaluation
  belongs_to :criterion, class_name: :EvaluationCriterion
  belongs_to :evaluation, class_name: :TeacherEvaluation


end
