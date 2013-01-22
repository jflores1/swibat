module UsersHelper

	def display_follow_actions followee
    if user_signed_in?
      following = Following.find_by_user_id_and_followee_id(current_user.id, followee.id)
      content_tag :div, :class => "following" do
        if following != nil         
          link_to "Unfollow", following, :method => :delete, class: "btn"          
        else
          link_to "Follow", follow_following_path(followee.id), :method => :post, class: "btn"
        end
      end
    else
      content_tag :div, class: "following" do
        link_to "Follow", new_user_registration_path, class: "btn"
      end
    end
	end
end
