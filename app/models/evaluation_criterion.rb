class EvaluationCriterion < ActiveRecord::Base
  attr_accessible :contents, :evaluation_domain_id, :evaluation_domain

  belongs_to :evaluation_domain
  has_many :evaluation_ratings

  validates :contents, presence: :true

  # duplication rules
  amoeba do
  	exclude_field [:evaluation_ratings]
  end
end
