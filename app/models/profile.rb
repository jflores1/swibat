# == Schema Information
#
# Table name: profiles
#
#  id         :integer          not null, primary key
#  prefix     :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Profile < ActiveRecord::Base
  attr_accessible :first_name, :last_name, :prefix
end
