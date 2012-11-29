# A class for functions related to language processing tasks
class NLPTools
	# Implementation of Dice's coefficient 
	# http://stackoverflow.com/questions/653157/a-better-similarity-ranking-algorithm-for-variable-length-strings
  def self.find_similarity first_string, second_string
  	first_string.downcase! 
		pairs1 = (0..first_string.length-2).collect {|i| first_string[i,2]}.reject {
		  |pair| pair.include? " "}
		second_string.downcase! 
		pairs2 = (0..second_string.length-2).collect {|i| second_string[i,2]}.reject {
		  |pair| pair.include? " "}
		union = pairs1.size + pairs2.size 
		intersection = 0 
		pairs1.each do |p1| 
		  0.upto(pairs2.size-1) do |i| 
		    if p1 == pairs2[i] 
		      intersection += 1 
		      pairs2.slice!(i) 
		      break 
		    end 
		  end 
		end 
		(2.0 * intersection) / union
  end

  # Weighted average of the values. The higher the pow value,
  # the more weight the bigger numbers have over the average
  def self.calculate_average numbers, pow
  	sum = 0
  	numbers.each do |num|
  		sum = sum + num**pow
  	end
  	sum = sum / numbers.length
  	sum**(1.0/pow)
  end

  # Returns the maximum similarity value between the string and
  # all of the strings in the candidate array
  def self.best_similarity objective, candidates
  	max = 0
  	candidates.each do |candidate|
  		dist = find_similarity(objective.objective, candidate)
  		max = dist if dist > max
  	end
  	max
  end 
end