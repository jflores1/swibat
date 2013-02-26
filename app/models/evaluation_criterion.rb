# == Schema Information
#
# Table name: evaluation_criteria
#
#  id                   :integer          not null, primary key
#  contents             :string(255)
#  evaluation_domain_id :integer
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#

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
