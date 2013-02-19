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

class JournalEntry < ActiveRecord::Base
  attr_accessible :cons, :pros
  belongs_to :lesson

  def self.belongs_to_course(course_id)
  	self.joins(lesson: {unit: :course}).where('courses.id = ?', course_id)
  end

end
