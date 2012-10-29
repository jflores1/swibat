# == Schema Information
#
# Table name: institutions
#
#  id             :integer          not null, primary key
#  name           :string(255)
#  enrollment     :string(255)
#  num_faculty    :string(255)
#  address_line_1 :string(255)
#  address_line_2 :string(255)
#  city           :string(255)
#  state          :string(255)
#  zip_code       :string(255)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

require 'spec_helper'

describe Institution do
  pending "add some examples to (or delete) #{__FILE__}"
end
