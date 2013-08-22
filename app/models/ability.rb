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
    end
    
    if user.role == "teacher" || user.role == "school_admin"
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
      can :manage, LessonActivity do |activity|
        activity.new_record? || activity.try(:user).try(:id) == user.id
      end

      can :manage, Post do |post|
        post.new_record? || post.try(:user).try(:id) == user.id
      end

      # Can delete comment only if they have created it
      can :destroy, Comment, :user_id => user.id
      # Can manage comments if they are the owners of the commentable of the comment (Course, Unit, etc.)
      can :manage, Comment do |comment|
        if comment.try(:commentable_type) == "TeacherEvaluation"
          comment.try(:commentable).try(:teacher_id) == user.id
        else
          comment.try(:commentable).try(:user).try(:id) == user.id
        end
      end          

      can :manage, User, :id => user.id
      can :read, User
      can :videos, User, institution_id: user.institution_id

      can :read, [Course, Lesson, Unit, Question, Answer]      

      can :manage, Video do |video|
        video.try(:uploader_id) == user.id || video.try(:user_id) == user.id        
      end
      can :new, Video

      can :autocomplete_institution_name, Institution
      
      can :read, Video do |video|
        video.try(:user).try(:institution) == user.institution
      end     

      # can [:read, :faculty], Institution, id: user.institution_id

      can :vote, :all
      can :flag, Flag
      can :evaluations, User, user_id: user.id
      can :read, TeacherEvaluation, teacher_id: user.id

    end

    if user.role == "school_admin"
      can :videos, User, institution_id: user.institution_id 
      can :manage, Institution, id: user.institution_id      
      can :manage, Comment
      can :manage, TeacherEvaluation
      can [:eval, :evaluations], User, institution_id: user.institution_id
      can :manage, Video do |video|
        video.try(:user).try(:institution_id) == user.institution_id
      end
    end

  end
end
