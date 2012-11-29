# == Schema Information
#
# Table name: objectives
#
#  id                 :integer          not null, primary key
#  objective          :string(255)
#  objectiveable_id   :integer
#  objectiveable_type :string(255)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

class Objective < ActiveRecord::Base
  attr_accessible :objective
  belongs_to :objectiveable, polymorphic: true

  # Returns similar objectiveable, based on a similarity measure between the objective sets
  def self.find_similar_objectiveables objectives, type, threshold = 0.3, limit = nil
  	# Fetch all objectivables of the same type from the database
  	candidates = type.constantize.all
  	# Instantiate the result array
  	result_set = []

  	# Iterate over each candidate objectivable, and calculate its similarity to our objectivable
  	candidates.each do |candidate|
  		if candidate.objectives.any?
	  		# calculate the best similarities between each objective in the candidate set and our own objectives
	  		best_similarities = []
	  		candidate.objectives.each do |obj|
	  			best_similarities << NLPTools.best_similarity(obj, objectives)
	  		end

	  		# calculate the similarity as a weighted average of its best similarities 
	  		# and put it into the result set if it meets the minimum threshold
	  		candidate_similarity = NLPTools.calculate_average(best_similarities, 5)
	  		result_set << {:objectiveable => candidate, :similarity => candidate_similarity} if candidate_similarity > threshold
  		end
  	end

  	# sort the result set by similarity, reverse it, so the highest are on top, and return the results
  	result_set = result_set.sort_by { |entry| entry[:similarity] }
  	limit ||= result_set.length  	
  	result_set.reverse[0..limit-1]
  end

end
