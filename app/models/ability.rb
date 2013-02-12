class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user permission to do.
    # If you pass :manage it will apply to every action. Other common actions here are
    # :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on. If you pass
    # :all it will apply to every resource. Otherwise pass a Ruby class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details: https://github.com/ryanb/cancan/wiki/Defining-Abilities

    user ||= User.new
    if user.role == "admin"
      can :manage, :all
    elsif user.role == "teacher"
      can :manage, Course do |course|
        course.new_record? || course.try(:user).try(:id) == user.id
      end
      can :manage, Lesson do |lesson|
        lesson.new_record? || lesson.try(:user).try(:id) == user.id
      end 
      can :manage, Unit do |unit|
        unit.new_record? || unit.try(:user).try(:id) == user.id
      end
      can :manage, Question do |question|
        question.new_record? || question.try(:user).try(:id) == user.id
      end
      can :manage, Answer do |answer|
        answer.new_record? || answer.try(:user).try(:id) == user.id
      end
      can :manage, Activity do |activity|
        activity.new_record? || activity.try(:user).try(:id) == user.id
      end

      can :manage, Post do |post|
        post.new_record? || post.try(:user).try(:id) == user.id
      end

      # Can delete comment only if they have created it
      can :destroy, Comment, :user_id => user.id
      # Can manage comments if they are the owners of the commentable of the comment (Course, Unit, etc.)
      can :manage, Comment do |comment|
        comment.try(:commentable).try(:user).try(:id) == user.id
      end
      # Can create comments if they are friends with the user the commentable belongs to
      can :create, Comment do |comment|
        comment.try(:commentable).try(:user) #.try(:friends).include? user
      end

      can :manage, User, :id => user.id
      can :read, User
      can :read, Course
      can :read, Lesson
      can :read, Unit
      can :read, Question
      can :read, Answer

      can :vote, :all
      can :flag, Flag

    elsif user.role == "school_admin"
      can :read, :all
      can :manage, Institution
    end
  end
end
