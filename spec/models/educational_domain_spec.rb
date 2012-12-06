# == Schema Information
#
# Table name: educational_domains
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  parent_id  :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe EducationalDomain do
  pending "add some examples to (or delete) #{__FILE__}"
end
