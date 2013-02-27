class EducationalStandardsController < ApplicationController
	autocomplete :educational_standard, :description, :full => true, :display_value => :display_value
end
