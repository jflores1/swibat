# == Schema Information
#
# Table name: objectives
#
#  id                 :integer          not null, primary key
#  objective          :string(255)
#  objectiveable_id   :integer
#  objectiveable_type :string(255)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

require 'spec_helper'

describe Objective do
  pending "add some examples to (or delete) #{__FILE__}"
end
