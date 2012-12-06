# == Schema Information
#
# Table name: standard_strands
#
#  id                    :integer          not null, primary key
#  name                  :string(255)      not null
#  educational_domain_id :integer
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#

require 'spec_helper'

describe StandardStrand do
  pending "add some examples to (or delete) #{__FILE__}"
end
