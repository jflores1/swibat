class TeacherEvaluation < ActiveRecord::Base
  attr_accessible :evaluation_template_id, :teacher_id

  belongs_to :teacher, class_name: :User
  belongs_to :evaluation_template
  has_many :evaluation_ratings, foreign_key: :evaluation_id, dependent: :destroy

  accepts_nested_attributes_for :evaluation_ratings
end
