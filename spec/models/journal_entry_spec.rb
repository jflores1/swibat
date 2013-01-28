# == Schema Information
#
# Table name: journal_entries
#
#  id            :integer          not null, primary key
#  average_score :float
#  median_score  :float
#  highest_score :float
#  lowest_score  :float
#  lesson_pros   :text
#  lesson_cons   :text
#  lesson_id     :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

require 'spec_helper'

describe JournalEntry do
  pending "add some examples to (or delete) #{__FILE__}"
end
