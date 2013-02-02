module UsersHelper

	def display_follow_actions followee
    if signed_in?
      content_tag :div, :class => "following", id: "follow-form" do
        if current_user.following?(@user)
          render 'users/unfollow'
        else
          render 'users/follow'
        end
      end
    else
      content_tag :div, class: "following", id: "follow-form" do
        link_to "Follow", new_user_registration_path, class: "btn"
      end
    end
	end

  def display_profile_institution(user)
    if user.institution.present?
      content_tag :dl, class:"dl-horizontal" do
        content_tag :dt, "Works at:"
        content_tag :dd, user.institution
      end
    else
      content_tag :p, ""
    end
  end
end
