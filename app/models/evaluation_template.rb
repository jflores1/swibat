# == Schema Information
#
# Table name: evaluation_templates
#
#  id             :integer          not null, primary key
#  institution_id :integer
#  published      :boolean
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class EvaluationTemplate < ActiveRecord::Base
  attr_accessible :institution_id, :published

  belongs_to :institution
  has_many :evaluation_domains, dependent: :destroy
  has_many :evaluations, class_name: :TeacherEvaluation


  def self.create_default_template_for(institution)
  	default_template = EvaluationTemplate.first
  	template = default_template.amoeba_dup
  	template.institution = institution
  	template.published = false
  	template.save

  	return template
  end

  # duplication rules
  amoeba do 
    exclude_field [:institution_id, :published, :evaluations]
  end

end
