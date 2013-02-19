class EvaluationTemplate < ActiveRecord::Base
  attr_accessible :institution_id, :published

  belongs_to :institution
  has_many :evaluation_domains, dependent: :destroy
end
