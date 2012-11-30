# == Schema Information
#
# Table name: professional_accomplishments
#
#  id                  :integer          not null, primary key
#  accomplishment_type :string(255)
#  name                :string(255)
#  year                :integer
#  user_id             :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

require 'spec_helper'

describe ProfessionalAccomplishment do
  pending "add some examples to (or delete) #{__FILE__}"
end
