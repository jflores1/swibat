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
#  objective_type     :string(255)      default("Goal")
#

class Objective < ActiveRecord::Base
  attr_accessible :objective, :objective_type
  belongs_to :objectiveable, polymorphic: true

  OBJECTIVE_TYPES = ["Goal", "Content", "Skill"]
  validate :valid_objective_type

  scope :content, where(objective_type: "Content")
  scope :skills, where(objective_type: "Skill")

  # Returns similar objectiveable
  def self.find_similar_objectiveables input_strings, type, based_on, threshold = 0.3, limit = nil
  	# Fetch all objectivables of the same type from the database
  	candidates = type.constantize.all
  	# Instantiate the result array
  	result_set = []

    if based_on == "objectives" # the similarity is calculated based on the common objectives
    	# Iterate over each candidate objectivable, and calculate its similarity to our objectivable
    	candidates.each do |candidate|
    		if candidate.objectives.any?
  	  		# calculate the best similarities between each objective in the candidate set and our own objectives
  	  		best_similarities = []
  	  		candidate.objectives.each do |candidate_objective|
  	  			best_similarities << NLPTools.best_similarity(candidate_objective.objective, input_strings)
  	  		end

  	  		# calculate the similarity as a weighted average of its best similarities 
  	  		# and put it into the result set if it meets the minimum threshold
  	  		candidate_similarity = NLPTools.calculate_average(best_similarities, 5)
  	  		result_set << {:objectiveable => candidate, :similarity => candidate_similarity} if candidate_similarity > threshold
    		end
    	end
    elsif based_on == "name" # the similarity is calculated based on the title of the objectiveable      
      candidates.each do |candidate|
        similarity = NLPTools.find_similarity(candidate.to_s, input_strings[0])
        result_set << {:objectiveable => candidate, :similarity => similarity} if similarity > threshold
      end

    end

  	# sort the result set by similarity, reverse it, so the highest are on top, and return the results
  	result_set = result_set.sort_by { |entry| entry[:similarity] }
  	limit ||= result_set.length  	
  	result_set.reverse[0..limit-1]
  end

  private
  def valid_objective_type
    errors.add(:objective_type, "is not a valid objective type") unless OBJECTIVE_TYPES.include? objective_type
  end

end
