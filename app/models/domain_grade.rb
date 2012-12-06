# == Schema Information
#
# Table name: domain_grades
#
#  id                    :integer          not null, primary key
#  educational_domain_id :integer
#  grade_id              :integer
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#

class DomainGrade < ActiveRecord::Base
  belongs_to :educational_domain
  belongs_to :grade
end
