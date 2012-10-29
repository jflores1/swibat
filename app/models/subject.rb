# == Schema Information
#
# Table name: subjects
#
#  id         :integer          not null, primary key
#  subject    :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Subject < ActiveRecord::Base
  attr_accessible :subject
  has_and_belongs_to_many :courses
end
