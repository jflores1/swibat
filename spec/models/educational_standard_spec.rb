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

require 'spec_helper'

describe EducationalStandard do
  pending "add some examples to (or delete) #{__FILE__}"
end
