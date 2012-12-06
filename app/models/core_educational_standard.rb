# == Schema Information
#
# Table name: educational_standards
#
#  id                 :integer          not null, primary key
#  name               :string(255)      not null
#  description        :text
#  url                :string(255)
#  standard_strand_id :integer
#  parent_id          :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

class CoreEducationalStandard < EducationalStandard
	attr_accessible :url
end
