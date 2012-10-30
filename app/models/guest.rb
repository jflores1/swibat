class Guest
  extend  ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations

  def initialize

  end

  def email
    'guest@test.com'
  end

  def create options = {}

  end

  def has_role? role
    role.to_sym == :guest
  end

  def persisted?
    false
  end
end