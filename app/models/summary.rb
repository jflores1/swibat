# == Schema Information
#
# Table name: summaries
#
#  id         :integer          not null, primary key
#  summary    :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Summary < ActiveRecord::Base
  attr_accessible :summary
end
