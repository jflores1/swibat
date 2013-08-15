# == Schema Information
#
# Table name: evaluation_templates
#
#  id             :integer          not null, primary key
#  institution_id :integer
#  published      :boolean
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  name           :string(255)
#

class EvaluationTemplate < ActiveRecord::Base
  attr_accessible :institution_id, :published, :name

  belongs_to :institution
  has_many :evaluation_domains, dependent: :destroy
  has_many :evaluations, class_name: :TeacherEvaluation

  validates :name, presence: :true

  scope :published, where(published: true)

  def self.create_default_template_for(institution, base_template_id)
  	default_template = EvaluationTemplate.find(base_template_id)
  	template = default_template.amoeba_dup
  	template.institution = institution
  	template.published = false
    template.name = "Evaluation Template " + (institution.evaluation_templates.count + 1).to_s
  	template.save

  	return template
  end

  # duplication rules
  amoeba do 
    exclude_field [:institution_id, :published, :evaluations]
  end

end
