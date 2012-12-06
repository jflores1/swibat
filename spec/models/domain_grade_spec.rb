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

require 'spec_helper'

describe DomainGrade do
  pending "add some examples to (or delete) #{__FILE__}"
end
