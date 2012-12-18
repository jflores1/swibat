require 'spec_helper'

describe "Flagging" do

	before do 
		sign_in_via_form			
		@course = FactoryGirl.create(:course, :user => @user)
		@unit = FactoryGirl.create(:unit, :course => @course)
		@lesson = FactoryGirl.create(:lesson, :unit => @unit)
		@question = FactoryGirl.create(:question, :user => @user)
  end

  context "When visiting the show page of" do
  	before { visit user_path(@user) }
  	describe "Users" do
  		it "should have a flag link" do 
  			page.should have_content("Flag")
  		end

  		it "should have a working flag link" do
  			expect { click_link "Flag" }.to change(@user.flags, :count).by(1)
  		end
  	end

  	describe "Courses" do
  		before { visit course_path(@course) }
  		it "should have a flag link" do
  			page.should have_content("Flag")
  		end

  		it "should have a working flag link" do
  			expect { click_link "Flag" }.to change(@course.flags, :count).by(1)
  		end
  	end

  	describe "Units" do
  		before { visit course_unit_path(@course, @unit) }
  		it "should have a flag link" do
  			page.should have_content("Flag")
  		end

  		it "should have a working flag link" do
  			expect { click_link "Flag" }.to change(@unit.flags, :count).by(1)
  		end
  	end

  	describe "Lessons" do
  		before { visit unit_lesson_path(@unit, @lesson) }
  		it "should have a flag link" do
  			page.should have_content("Flag")
  		end

  		it "should have a working flag link" do
  			expect { click_link "Flag" }.to change(@lesson.flags, :count).by(1)
  		end
  	end

  	describe "Questions" do
  		before { visit question_path(@question) }
  		it "should have a flag link" do
  			page.should have_content("Flag")
  		end
  		it "should have a working flag link" do
  			expect { click_link "Flag" }.to change(@question.flags, :count).by(1)
  		end
  	end

	end
end