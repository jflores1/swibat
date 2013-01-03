module SearchHelper

	def title_for result
		case result.searchable_type
		when "Answer"
		  result.searchable.question.to_s		
		else
		  result.searchable.to_s
		end
	end

	def path_for result
		case result.searchable_type
		when "Answer"
			question_path result.searchable.question
		when "Unit"
			course_unit_path result.searchable.course, result.searchable
		when "Lesson"
			unit_lesson_path result.searchable.unit, result.searchable
		else
	  	polymorphic_path result.searchable
		end
	end

end
