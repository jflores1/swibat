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

  # duplication rules
  amoeba do
  	enable
  end
end
