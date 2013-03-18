# == Schema Information
#
# Table name: evaluation_domains
#
#  id                     :integer          not null, primary key
#  name                   :string(255)
#  evaluation_template_id :integer
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#

class EvaluationDomain < ActiveRecord::Base
  attr_accessible :evaluation_template_id, :name

  belongs_to :evaluation_template
  has_many :evaluation_criteria, dependent: :destroy

  validates :name, presence: :true

  def calculate_score(teacher_evaluation)
  	domain_score = 0
  	criteria_count = 0	
  	self.evaluation_criteria.each do |criterion|
  		rating = EvaluationRating.find_by_criterion_id_and_evaluation_id(criterion.id, teacher_evaluation.id)
  		next if rating == nil || rating.score == -1
  		domain_score += rating.score
  		criteria_count += 1
  	end
  	domain_score /= criteria_count.to_f
		domain_score = 0 if domain_score.nan?

    # Next line transforms the score into percentage
    # domain_score = domain_score *100 / 4.0

  	return domain_score
  end

  # duplication rules
  amoeba do
  	enable
  end
end
