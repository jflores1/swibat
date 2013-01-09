module ReputationsHelper 

	def generate_vote_form resource, path
    if user_signed_in?
      current_evaluation = ReputationSystem::Evaluation.find_by_reputation_name_and_source_and_target(:votes, current_user, resource)
      content_tag :div, :class => "vote" do
        # Upvote
        if current_evaluation && current_evaluation.value > 0
          concat link_to raw('<div class="arrow upvote-active"></div>'), path + "?type=clear",  method: "post"
        else
          concat link_to raw('<div class="arrow upvote"></div>'), path + "?type=up",  method: "post"
        end
        # Vote count
        concat ( content_tag :div, :class => "vote-count" do
          concat resource.reputation_for(:votes).to_i
        end )
        # Downvote
        if current_evaluation && current_evaluation.value < 0
          concat link_to raw('<div class="arrow downvote-active"></div>'), path + "?type=clear", method: "post"
        else
          concat link_to raw('<div class="arrow downvote"></div>'), path + "?type=down", method: "post"
        end
      end
    else
      content_tag :div, class: "vote-display" do
        concat ( content_tag :div, :class => "vote-count" do
          concat resource.reputation_for(:votes).to_i
        end ) + "votes"
      end
    end
  end

  def cryptify(reputation)
    reputation.to_i * 10
  end

end