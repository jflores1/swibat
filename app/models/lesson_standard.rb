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

class LessonStandard < ActiveRecord::Base

	belongs_to :lesson
  belongs_to :educational_standard
  
end
