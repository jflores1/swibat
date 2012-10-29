class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :token_authenticatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  tango_user

  validates_uniqueness_of :email, case_sensitive: false

  def roles_list
    [:admin, :school_admin, :teacher]
  end

  def self.guest
    session[:guest_user] ||= Guest.new
  end
end
