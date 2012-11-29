# == Schema Information
#
# Table name: leads
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  role       :string(255)
#  school     :string(255)
#  email      :string(255)
#  phone      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Lead < ActiveRecord::Base
  attr_accessible :email, :name, :phone, :role, :school

  ROLES  = %w[teacher administrator]
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  before_validation do |lead|
    lead.role = role.downcase
    lead.phone = phone.gsub(/\D/,'')
    lead.email = email.downcase
  end

  before_save do |lead|
    lead.school = school.titleize
    lead.name = name.titleize
  end

  after_save :new_lead_notification

  validate  :valid_role
  validates :email, :name, :phone, :role, :school, presence: true
  validates :phone, length: {in:6..13}
  validates :email, format: {with: VALID_EMAIL_REGEX}


  def valid_role
    errors.add(:role, "is not a valid role") unless ROLES.include? role
  end

  #private methods
  private
  def new_lead_notification
    LeadMailer.new_lead(self).deliver
  end
end
