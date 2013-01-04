require 'spec_helper'

describe "Search" do
	before do 
		sign_in_via_form		
		@course = FactoryGirl.create(:course, user: @user, course_name: "My first course", course_summary: "course summary")
		@unit = FactoryGirl.create(:unit, course: @course, unit_title: "My first unit")
		FactoryGirl.create(:unit, course: @course, unit_title: "My second unit")
		@lesson = FactoryGirl.create(:lesson, unit: @unit, lesson_title: "My first lesson")
		@question = FactoryGirl.create(:question, title: "My question", text: "My first question text", user: @user)
		@answer = @question.answers.create(text: "My first answer", user: @user)
		@question.answers.create(text: "My second answer", user: @user)
		@question.answers.create(text: "My third answer", user: @user)
  end

  describe 'search form' do
  	before {visit search_path}

	  it 'should display the search form' do
	  	page.should have_selector('.form-search')  	
	  end

	  it 'should have a working search form' do
	  	within(".form-search") do
		  	fill_in 'query',     with: "first"
	  		click_button "Search"
			end
			page.should have_content('Displaying search results for: first')
  		page.should have_selector('.search-result', count: 5)
	  end
	end

  describe 'search engine' do 
	  it 'should return valid results' do
	  	results = PgSearch.multisearch("first")
	  	results.count.should be(5)	  	
	  end
	end
end