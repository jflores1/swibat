class EvaluationCriterion < ActiveRecord::Base
  attr_accessible :contents, :evaluation_domain_id

  belongs_to :evaluation_domain

  validates :contents, presence: :true
end
