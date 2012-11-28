# == Schema Information
#
# Table name: objectives
#
#  id                 :integer          not null, primary key
#  objective          :string(255)
#  objectiveable_id   :integer
#  objectiveable_type :string(255)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

class Objective < ActiveRecord::Base
  attr_accessible :objective
  belongs_to :objectiveable, polymorphic: true
end
