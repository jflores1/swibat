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
#  role                   :string(255)      default("teacher")
#  first_name             :string(255)
#  last_name              :string(255)
#  institution            :string(255)
#  image_file_name        :string(255)
#  image_content_type     :string(255)
#  image_file_size        :integer
#  image_updated_at       :datetime
#  profile_summary        :text
#  provider               :string(255)
#  uid                    :string(255)
#

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :omniauthable,
         :recoverable, :rememberable, :trackable, :validatable, :token_authenticatable

  has_attached_file :image, 
                    :styles => { :medium => "300x300#", :x100 => "100x100#", :x50 => "50x50#" },
                    :storage => :s3, :s3_credentials => "#{Rails.root}/config/amazon_s3.yml",
                    :path => "users/:id-:style.:extension",
                    :default_url => "https://s3.amazonaws.com/swibat_development/icon-graduation-cap.png"

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
  has_many :posts
  has_many :units, :through => :courses
  has_many :lessons, :through => :units
  has_many :friend_courses, through: :people_followed, source: :courses
  has_many :microposts, dependent: :destroy
  
  # Define the friendship relations with some semantics.
  has_many  :followings,
            foreign_key: :user_id,
            dependent: :destroy
  
  has_many  :incoming_followings,             
            :class_name => :Following,
            foreign_key: :followee_id

  has_many  :followers, through: :incoming_followings, source: :user
  has_many  :people_followed, through: :followings, source: :followee

  has_reputation :reputation, :source => [
    { :reputation => :votes, :of => :questions, :weight => 0.15},
    { :reputation => :votes, :of => :answers, :weight => 0.15},
    { :reputation => :votes, :of => :courses, :weight => 0.3},
    { :reputation => :votes, :of => :units, :weight => 0.25},
    { :reputation => :votes, :of => :lessons, :weight => 0.15}
  ]

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

  after_create :signup_confirmation

  ROLES = %w[admin school_admin teacher]

  def role?(role)
    ROLES.include? role.to_s
  end

  def full_name
    "#{self.first_name} #{self.last_name}"
  end

  def to_param
    "#{id}-#{full_name.strip.parameterize}"
  end

  def feed
    Micropost.from_users_followed_by(self)
  end

  def following?(other_user)
    followings.find_by_followee_id(other_user.id)
  end

  def follow!(other_user)
    followings.create!(followee_id: other_user.id)
  end

  def unfollow!(other_user)
    followings.find_by_followee_id(other_user.id).destroy
  end

  #Private Methods
  private

  def valid_role
    errors.add(:role, "is not a valid role") unless ROLES.include? role
  end

  def signup_confirmation
    UserMailer.signup_confirmation(self).deliver
  end

  #Omniauth support
  def self.from_omniauth(auth)
    where(auth.slice(:provider, :uid)).first_or_create do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.email = auth.info.email
    end
  end

  def self.new_with_session(params, session)
    if session["devise.user_attributes"]
      new(session["devise.user_attributes"], without_protection: true) do |user|
        user.attributes = params
        user.valid?
      end
    else
      super
    end
  end

  def password_required?
    super && provider.blank?
  end

  def update_with_password(params, *options)
    if encrypted_password.blank?
      update_attributes(params, *options)
    else
      super
    end
  end

end
