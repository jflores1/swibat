require 'spec_helper'

describe "LessonPages" do
	before do 
		sign_in_via_form
		@course = FactoryGirl.create(:course)
		@unit = FactoryGirl.create(:unit, :course => @course)		
	end

	describe "Creating a new lesson" do
		before { visit new_unit_lesson_path @unit }
		let(:submit_button){"Submit"}

		it "should display the form" do
			page.should have_selector('form')
		end

		describe "With invalid attributes" do
			it "should show errors on invalid submit" do
				click_button submit_button
				page.should have_selector('#error_explanation')
			end
		end

		describe "With valid attributes and no resources" do
			it "should submit the form and create the lesson" do
				fill_in 'lesson_title',     				with: "My lsson"
				fill_in 'lesson_start_date',    	 	with: "2011-01-01"
				fill_in 'lesson_end_date',	    	 	with: "2012-01-01"
				fill_in 'lesson_status', 					  with: "Started"
				fill_in 'prior_knowledge', 					with: "None"
				expect { click_button submit_button }.to change(Lesson, :count).by(1)
			end
		end

		describe "With valid attributes and resources" do
			it "should submit the form and create the lesson with resources" do
				fill_in 'lesson_title',     				with: "My lsson"
				fill_in 'lesson_start_date',    	 	with: "2011-01-01"
				fill_in 'lesson_end_date',	    	 	with: "2012-01-01"
				fill_in 'lesson_status', 					  with: "Started"
				fill_in 'prior_knowledge', 					with: "None"
				fill_in 'lesson_resources_attributes_0_name', 	with: "Lesson notes"
				page.attach_file('lesson_resources_attributes_0_upload', Rails.root + 'spec/fixtures/files/upload.txt') 
				expect { click_button submit_button }.to change(Lesson, :count).by(1)
				Lesson.last.resources.count.should == 1
				resource = Resource.last
				resource.name.should == "Lesson notes"
				resource.upload_file_name.should == "upload.txt"
			end
		end
	end
end