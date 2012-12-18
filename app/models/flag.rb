# == Schema Information
#
# Table name: flags
#
#  id             :integer          not null, primary key
#  flaggable_id   :integer
#  flaggable_type :string(255)
#  user_id        :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class Flag < ActiveRecord::Base
  attr_accessible :flaggable_id, :flaggable_type, :user_id

  belongs_to :flaggable, :polymorphic => true
  belongs_to :user

  validates :flaggable_id, :uniqueness => {:scope => [:user_id, :flaggable_type], :message => "You have already flagged this resource"}

  def self.build_from(obj, user_id)
    flag = self.new
    flag.flaggable_id = obj.id
    flag.flaggable_type = obj.class.base_class.name
    flag.user_id = user_id
    flag
  end

  def self.find_flaggable(flaggable_str, flaggable_id)
    flaggable_str.constantize.find(flaggable_id)
  end

end
