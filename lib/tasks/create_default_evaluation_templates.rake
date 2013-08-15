require 'csv'

namespace :db do
  desc "Fill database with teachers from Our Lady Of Mercy Catholic School"
  task create_evaluation_templates: :environment do
  	puts "Creating default evaluation templates"
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
end