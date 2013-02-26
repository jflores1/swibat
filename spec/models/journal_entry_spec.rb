# == Schema Information
#
# Table name: journal_entries
#
#  id         :integer          not null, primary key
#  pros       :text
#  cons       :text
#  lesson_id  :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe JournalEntry do
  
  describe "Attributes" do
  	it {should respond_to(:lesson)}
    it {should respond_to(:pros)}
    it {should respond_to(:cons)}
  end


end
