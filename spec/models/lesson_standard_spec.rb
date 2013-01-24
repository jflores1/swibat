# == Schema Information
#
# Table name: lesson_standards
#
#  id                      :integer          not null, primary key
#  educational_standard_id :integer
#  lesson_id               :integer
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#

require 'spec_helper'

describe LessonStandard do
  pending "add some examples to (or delete) #{__FILE__}"
end
