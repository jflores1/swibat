# == Schema Information
#
# Table name: evaluation_ratings
#
#  id            :integer          not null, primary key
#  evaluation_id :integer
#  criterion_id  :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  score         :integer
#

require 'spec_helper'

describe EvaluationRating do
  pending "add some examples to (or delete) #{__FILE__}"
end
