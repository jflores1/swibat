class RoleConstraint
  def initialize(*roles)
    @roles = roles
  end

  def matches?(request)
    @roles.include? request.env['warden'].user.try(:role)
  end
end