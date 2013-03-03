require 'csv'

namespace :db do
  desc "Fill database with teachers from Our Lady Of Mercy Catholic School"
  task olomteachers: :environment do
  	institution = Institution.find_by_name("OUR LADY OF MERCY ELEMENTARY SCHOOL")
  	CSV.foreach("#{Rails.root}/lib/tasks/data/olomschool_teachers.csv", :headers => :first_row) do |row|
	    # begin
	    	user = User.new
	    	user.first_name = row[0].strip
	    	user.last_name = row[1].strip
	    	user.email = row[2].strip
	    	user.password = "password"
	    	user.password_confirmation = "password"
	    	user.profile_summary = row[3].strip
	    	user.institution = institution
	    	user.role = "teacher"
	      user.save
	    # rescue
	    # 	puts "Error"
	    #   next
	    # end
	  end
  end
end