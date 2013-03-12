# == Schema Information
#
# Table name: teacher_evaluations
#
#  id                     :integer          not null, primary key
#  teacher_id             :integer
#  evaluation_template_id :integer
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  eval_type              :string(255)
#

class TeacherEvaluation < ActiveRecord::Base
  attr_accessible :evaluation_template_id, :teacher_id, :eval_type

  belongs_to :teacher, class_name: :User
  belongs_to :evaluation_template
  has_many :evaluation_ratings, foreign_key: :evaluation_id, dependent: :destroy
  has_one :video, foreign_key: :observation_id

  def calculate_score
  	evaluation_score = 0.0
  	domain_count = 0
 		self.evaluation_template.evaluation_domains.each do |domain|
 			domain_score = domain.calculate_score(self)
 			next if domain_score == 0
 			evaluation_score += domain_score
 			domain_count += 1
    end
    evaluation_score = evaluation_score / domain_count.to_f
    evaluation_score = 0.0 if evaluation_score.nan?
    return evaluation_score
  end

  accepts_nested_attributes_for :evaluation_ratings
end
