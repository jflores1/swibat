module UsersHelper

	def display_friendship_actions friend
		friendship = Friendship.find_by_user_id_and_friend_id(current_user.id, friend.id)
		content_tag :div, :class => "friendship" do
		  	if friendship != nil
				if friendship.status == 'accepted'
					link_to "Disconnect", friendship, :method => :delete, class: "btn"
				elsif friendship.requested_by?(current_user)
					link_to "Revoke Request", friendship, :method => :delete, class: "btn"
				elsif friendship.requested_by?(friend)
					link_to("Accept Connection", accept_friendship_path(friendship), :method => :post, class: "btn") + ' ' +
					link_to("Decline Connection", friendship, :method => :delete, class: "btn")
				end
			else
				link_to "Connect", add_friendship_path(friend.id), :method => :post, class: "btn"
			end			
		end		
	end
end
