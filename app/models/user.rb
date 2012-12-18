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
#  image_file_name        :string(255)
#  image_content_type     :string(255)
#  image_file_size        :integer
#  image_updated_at       :datetime
#  profile_summary        :text
#

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :token_authenticatable

  has_attached_file :image, 
                    :styles => { :medium => "300x300#", :x100 => "100x100#", :x50 => "50x50#" },
                    :storage => :s3, :s3_credentials => "#{Rails.root}/config/amazon_s3.yml",
                    :path => "users/:id-:style.:extension",
                    :default_url => "https://s3.amazonaws.com/trancepodium/images/unknown.jpg"

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :role, :first_name, :last_name, :institution, :image, :profile_summary, :professional_educations_attributes, :specialties_attributes, :professional_accomplishments_attributes, :links_attributes
  has_many :courses
  has_many :professional_educations
  has_many :professional_accomplishments
  has_many :links
  has_many :specialties
  has_many :questions
  has_many :answers
  has_many :flags
  
  # Define the friendship relations with some semantics.
  has_many :friendships, :conditions => "status = 'accepted'"
  has_many :friends, :through => :friendships

  has_many :sent_friend_requests, 
           :class_name => :Friendship,           
           :conditions => "status = 'pending'"           

  has_many :incoming_friend_requests,
           :class_name => :Friendship,
           :conditions => "status = 'requested'"           

  accepts_nested_attributes_for :professional_educations, :reject_if => lambda { |a| a[:school_name].blank? }, allow_destroy: true
  accepts_nested_attributes_for :professional_accomplishments, :reject_if => lambda { |a| a[:name].blank? }, allow_destroy: true
  accepts_nested_attributes_for :links, :reject_if => lambda { |a| a[:url].blank? }, allow_destroy: true
  accepts_nested_attributes_for :specialties, :reject_if => lambda { |a| a[:name].blank? }, allow_destroy: true

  validate :valid_role
  validates_uniqueness_of :email, case_sensitive: false
  validates :first_name, :last_name, :role, :institution, :email, presence: true
  validates :profile_summary, length:{maximum: 160}, allow_blank: true
  validates_attachment_size :image, :less_than => 2.megabytes
  validates_attachment_content_type :image, :content_type => ['image/jpeg', 'image/png', 'image/gif']

  before_save do |user|
    user.first_name = first_name.capitalize
    user.last_name = last_name.capitalize
    user.role = role.downcase
    user.institution = institution.titleize
  end

  ROLES = %w[admin school_admin teacher]

  def role?(role)
    ROLES.include? role.to_s
  end

  def full_name
    self.first_name + " " + self.last_name
  end

  def friends_with?(user)
    self.friends.include?(user)
  end

  private

  def valid_role
    errors.add(:role, "is not a valid role") unless ROLES.include? role
  end

end
