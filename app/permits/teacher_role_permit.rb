class TeacherRolePermit < CanTango::RolePermit
  def initialize ability
    super
  end

  protected

  def permit_rules
    # insert your can, cannot and any other rule statements here
    can :manage, [Unit, Lesson]
    
    
  end

  module Cached
    def permit_rules
    end
  end

  module NonCached
    def permit_rules
    end
  end
end
