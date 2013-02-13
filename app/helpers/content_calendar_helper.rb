module ContentCalendarHelper

	MONTH_LIST = ["january", "february", "march", "april", "may", "june", "july", "august", "september", "october", "november", "december"]

	def calendar_for_single_course(course)		
		calendar = initialize_calendar_hash(course)  	  	

		course.units.each do |unit|      
      dates = list_months_in_date_range(unit.expected_start_date, unit.expected_end_date)
      dates.each do |date|
        key = MONTH_LIST[date.month-1] + " " + date.year.to_s
        calendar[key.to_sym][:units] ||= []
        calendar[key.to_sym][:units] << unit
      end
    end 
    calendar
	end

	def calendar_for_multiple_courses(courses)
		calendar = initialize_calendar_hash(courses)  

		courses.each do |course|
      course.units.each do |unit|      
        dates = list_months_in_date_range(unit.expected_start_date, unit.expected_end_date)
        dates.each do |date|
          key = MONTH_LIST[date.month-1] + " " + date.year.to_s
          calendar[key.to_sym][course.id.to_s.to_sym] ||= {}
          calendar[key.to_sym][course.id.to_s.to_sym][:units] ||= []
          calendar[key.to_sym][course.id.to_s.to_sym][:units] << unit
        end
      end 
    end	  	
    calendar
	end

	private
	
		def extract_date_range(courses)
			if !courses.kind_of?(Array)
				courses = [courses]
			end

			min_date = courses.first.units.first.expected_start_date
	    max_date = courses.first.units.first.expected_end_date
	    courses.each do |course|
	      course.units.each do |unit|
	        min_date = unit.expected_start_date if min_date > unit.expected_start_date
	        max_date = unit.expected_end_date if max_date < unit.expected_end_date
	      end
	    end

	    [min_date, max_date]
		end

		def list_months_in_date_range start_date, end_date    
	    m = Date.new start_date.year, start_date.month
	    result = []
	    while m <= end_date
	      result << m
	      m >>= 1
	    end
	    result
	  end 

	  def initialize_calendar_hash(courses)  	  	
	  	calendar = {}
	  	
	  	stard_date, end_date = extract_date_range(courses)
			dates = list_months_in_date_range(stard_date, end_date)

	    dates.each do |date|
	      key = MONTH_LIST[date.month-1] + " " + date.year.to_s
	      calendar[key.to_sym] = {}
	    end
	    calendar
	  end

end