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
  attr_accessible :average_score, :highest_score, :lesson_cons, :lesson_pros, :lowest_score, :median_score
  belongs_to :lesson

  validates :average_score, presence: true, numericality: true, inclusion: {in: 0..100, message: 'must be between 0 and 100'}  
  validates :highest_score, presence: true, numericality: true, inclusion: {in: 0..100, message: 'must be between 0 and 100'}  
  validates :lowest_score, presence: true, numericality: true, inclusion: {in: 0..100, message: 'must be between 0 and 100'}  
  validates :median_score, presence: true, numericality: true, inclusion: {in: 0..100, message: 'must be between 0 and 100'}  

end
