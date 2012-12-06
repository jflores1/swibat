# == Schema Information
#
# Table name: standard_strands
#
#  id                    :integer          not null, primary key
#  name                  :string(255)      not null
#  educational_domain_id :integer
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#

class StandardStrand < ActiveRecord::Base
  attr_accessible :name  
  belongs_to :educational_domain
  has_many :educational_standards, :dependent => :destroy
end
