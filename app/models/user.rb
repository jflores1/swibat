# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0)
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  role                   :string(255)
#  first_name             :string(255)
#  last_name              :string(255)
#  institution            :string(255)
#

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :token_authenticatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :role, :first_name, :last_name, :institution
  has_many :courses

  before_save do |user|
    user.first_name = first_name.capitalize
    user.last_name = last_name.capitalize
    user.role = role.downcase
    user.institution = institution.titleize
  end

  validate :valid_role
  validates_uniqueness_of :email, case_sensitive: false
  validates :first_name, :last_name, :role, :institution, presence: true

  ROLES = %w[admin school_admin teacher]

  def role?(role)
    ROLES.include? role.to_s
  end

  def valid_role
    errors.add(:role, message:"Sorry, that's not a valid role") unless ROLES.include? role
  end

end
