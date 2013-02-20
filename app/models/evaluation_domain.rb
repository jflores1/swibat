class EvaluationDomain < ActiveRecord::Base
  attr_accessible :evaluation_template_id, :name

  belongs_to :evaluation_template
  has_many :evaluation_criteria, dependent: :destroy

  validates :name, presence: :true
end
