# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

require 'csv'

#Subjects
puts "Creating subjects"
if !Subject.any?
  subjects = ["English", "Science", "Math", "Social Studies", "Foreign Language", "Art", "Humanities", "Health & PE", "Religion"]
  subjects.sort.each do |subject|
    Subject.find_or_create_by_subject(subject)
  end
end

# Grades
puts "Creating grades"
if Grade.any?
  grades = ["Kindergarten", "Grade 1", "Grade 2", "Grade 3", "Grade 4", "Grade 5", "Grade 6", "Grade 7", 
    "Grade 8", "Grade 9", "Grade 10", "Grade 11", "Grade 12", "High School"] 
  grades.each do |grade|
    Grade.find_or_create_by_grade_level(grade)
  end
end

# Importing the CoreStandards
if !EducationalStandard.any?
  ["english.csv", "math.csv"].each do |dataset|
    puts "Importing the Core Standards: " + dataset

    root_domain = nil
    if dataset == "english.csv"
      root_domain = EducationalDomain.find_or_create_by_name("English Language Arts")  
    else
      root_domain = EducationalDomain.find_or_create_by_name("Mathematics")  
    end

    # iterate through csv file
    CSV.foreach("#{Rails.root}/db/seed_data/" + dataset, :headers => :first_row) do |row|
      
      # pull columns into variables
      name = row[0].strip
      description = row[1].strip
      url = row[2].strip
      domain_name = row[3].strip
      grade = row[4].strip
      strand = row[5].strip
      parent = row[6].blank? ? nil : row[6].strip
      
      parent_domain_name = nil

      # construct grades array from the grade column
      grades = []
      # Transform grade range into array of grades
      puts "Grade: " + grade
      if grade.include?('-') # Grade 10-11
        range = grade.gsub("Grade ", "")
        range_values = range.split("-")
        range_start = range_values[0].to_i
        range_end = range_values[1].to_i
        (range_start..range_end).each do |grade_num|
          g = Grade.find_by_grade_level("Grade " + grade_num.to_s)
          grades << g
        end
      elsif grade.include?(":") # High School: Number and Quantity
        grade_parts = grade.split(": ")
        g = Grade.find_by_grade_level(grade_parts[0])
        grades << g
        parent_domain_name = grade_parts[1]
      else      
        g = Grade.find_by_grade_level(grade)
        grades << g
      end
      puts "Found " + grades.count.to_s + " grades"
      parent_domain = nil
      # if there's a parent domain
      if parent_domain_name != nil
        grades.each do |g|
          parent_domain = g.educational_domains.first(:conditions => {:name => parent_domain_name})      
          if parent_domain != nil
            break
          end
        end

        if parent_domain == nil      
          parent_domain = EducationalDomain.create(:name => parent_domain_name, :parent => root_domain)
        end
        unique_grades = []
        parent_domain.grades.each do |g|
          unique_grades << g.id unless unique_grades.include?(g.id)
        end
        grades.each do |g|      
          parent_domain.grades << g unless unique_grades.include?(g.id)
        end      
        parent_domain.save      
      end

      # find or create the domain
      domain = nil
      puts "Domain : " + domain_name
      grades.each do |g|
        domain = g.educational_domains.first(:conditions => {:name => domain_name})      
        if domain != nil
          puts "Existing domain"
          break
        end
      end

      if domain == nil
        puts "Domain doesn't exist. Creating: " + domain_name

        domain = EducationalDomain.create(:name => domain_name)
        if parent_domain != nil
          domain.parent = parent_domain
        else
          domain.parent = root_domain
        end
      end
      unique_grades = []
      domain.grades.each do |g|
        unique_grades << g.id unless unique_grades.include?(g.id)
      end
      grades.each do |g|      
        domain.grades << g unless unique_grades.include?(g.id)
      end

      domain.save
      
      standard_strand = domain.standard_strands.first(:conditions => {:name => strand})

      if standard_strand == nil
        standard_strand = domain.standard_strands.create(:name => strand)
      end

      puts "Standard name: " + name
      standard = CoreEducationalStandard.new
      standard.name = name
      standard.description = description
      standard.url = url
      standard.standard_strand = standard_strand
      if !parent.blank?
        parent_standard = CoreEducationalStandard.find_by_name(parent)
        standard.parent = parent_standard
      end

      standard.save
    end
  end
end

# Creating a default evaluation template
puts "Creating default evaluation templates"
if !EvaluationTemplate.any? 
  ["Danielson Framework", "Marzano Framework"].each do |framework|
    if framework == 'Danielson Framework'
      filename = 'danielson_evaluation_template.csv'
    else
      filename = 'marzano_evaluation_template.csv'
    end     
    template = EvaluationTemplate.create(published: true, name: framework)    
    CSV.foreach("#{Rails.root}/db/seed_data/evaluation_templates/" + filename, :headers => :first_row) do |row|
      domain_name = row[0].strip
      criterion_contents = row[1].strip  
      domain = EvaluationDomain.find_or_create_by_name_and_evaluation_template_id(domain_name, template.id)
      domain.evaluation_template = template
      domain.save
      criterion = EvaluationCriterion.create(evaluation_domain: domain, contents: criterion_contents)
    end
  end
end

if !Institution.any?
  # Importing schools
  puts "Importing private schools"
  CSV.foreach("#{Rails.root}/db/seed_data/private_schools.csv", :headers => :first_row) do |row|
    begin
      institution = Institution.new
      institution.name = row[0].strip
      institution.state = row[1].strip if row[1]
      institution.address_line_1 = row[3].strip if row[3]
      institution.city = row[4].strip if row[4]
      institution.zip_code = row[6].strip if row[6]
      institution.save
    rescue
      next
    end
  end

  puts "Importing public schools"
  CSV.foreach("#{Rails.root}/db/seed_data/public_schools.csv", :headers => :first_row) do |row|
    begin
      institution = Institution.new
      institution.name = row[0].strip
      institution.state = row[1].strip.upcase if row[1]
      institution.address_line_1 = row[2].strip if row[2]
      institution.city = row[3].strip if row[3]
      institution.zip_code = row[5].strip if row[5]
      institution.latitude = row[16].strip.to_f if row[16]
      institution.longitude = row[17].strip.to_f if row[17]
      institution.save
    rescue
      next
    end
  end
end