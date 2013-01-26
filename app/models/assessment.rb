# == Schema Information
#
# Table name: assessments
#
#  id              :integer          not null, primary key
#  assessment_name :string(255)
#  assessable_id   :integer
#  assessable_type :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class Assessment < ActiveRecord::Base
  attr_accessible :assessment_name
  belongs_to :assessable, polymorphic: true

end
