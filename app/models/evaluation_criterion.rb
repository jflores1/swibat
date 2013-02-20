class EvaluationCriterion < ActiveRecord::Base
  attr_accessible :contents, :evaluation_domain_id

  belongs_to :evaluation_domain
  has_many :evaluation_ratings

  validates :contents, presence: :true
end
