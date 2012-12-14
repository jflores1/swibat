require 'spec_helper'

describe "QuestionPages" do
	
	context "When a user is signed in" do
		before do			
			sign_in_via_form
			@my_question = FactoryGirl.create(:question, title:"My question title", text:"My question text", user:@user)
			@other_user = FactoryGirl.create(:user, email:"marjan@test.com", first_name:"marjan", last_name:"georgiev")
			@other_question = FactoryGirl.create(:question, title:"Other question title", text:"Other question text", user:@other_user)
			visit questions_path
		end

		describe "Questions#index" do
			it "should display all questions" do
				page.should have_content("My question title")
				page.should have_content("Other question title")
			end

			it "should have a link for new question" do
				page.should have_content("Ask a Question")				
			end

			it "the ask a question link should be working" do
				click_link "Ask a Question"
				page.current_url == new_question_url
			end
		end

		describe "Questions#show" do
			before {visit question_path @my_question}
			
			it "should display the question" do
				page.should have_content("My question title")
				page.should have_content("My question text")
				page.should have_content(@user.full_name)
			end

			it "should display the answer form" do
				page.should have_selector("#new_answer")
			end

			it "should successfully create an answer" do 
				fill_in 'answer_text',     with: "this is my answer"
				click_button "Submit Answer"
				page.should have_content "this is my answer"
				@my_question.answers.count.should == 1
			end

			it "should display the voting buttons" do
				page.should have_selector(".vote")
			end


			it "should have working upvote button" do
				@my_question.reputation_for(:votes).to_i.should == 0
				upvote = find(".upvote")				
				upvote.find("a").click
				@my_question.reputation_for(:votes).to_i.should == 1
			end

			it "should have working downpvote button" do
				@my_question.reputation_for(:votes).to_i.should == 0
				downvote = find(".downvote")				
				downvote.find("a").click
				@my_question.reputation_for(:votes).to_i.should == -1
			end

			context "when the question has answers" do
				before do 
					@answer = @my_question.answers.create(text:"My answer", user:@other_user) 
					visit question_path @my_question
				end

				it "should display answers" do
					page.should have_content("My answer")
					page.should have_content(@other_user.full_name)
				end

				it "should display the voting button for the answers too" do
					page.should have_selector(".vote", count: 2) # the first one is for the question itself
				end

				it "should have working upvote button" do
					@answer.reputation_for(:votes).to_i.should == 0
					upvote = find('.answer').find(".upvote")				
					upvote.find("a").click
					@answer.reload.reputation_for(:votes).to_i.should == 1
				end

				it "should have working downpvote button" do
					@answer.reputation_for(:votes).to_i.should == 0
					downvote = find('.answer').find(".downvote")				
					downvote.find("a").click
					@answer.reputation_for(:votes).to_i.should == -1
				end
			end

			context "when it's my own question" do
				before {visit question_path @my_question}

				it "should show me edit and delete buttons" do
					page.should have_xpath('//a[@href="/questions/1/edit"]')
					page.should have_xpath('//a[@href="/questions/1"]')					
				end
			end

			context "when it's another user's question" do 
				before {visit question_path @other_question}

				it "should not show me edit and delete buttons" do
					page.should_not have_xpath('//a[@href="/questions/1/edit"]')
					page.should_not have_xpath('//a[@href="/questions/1"]')
				end
			end

		end

		describe "Answers#new" do
			before { visit new_question_answer_path @my_question }

			it "should display the form" do
				page.should have_selector("#new_answer")
			end

			it "should successfully create an answer" do 
				fill_in 'answer_text',     with: "this is my answer"
				click_button "Submit Answer"
				page.should have_content "this is my answer"
				@my_question.answers.count.should == 1
			end

			it "should show errors if no text is entered" do 
				click_button "Submit Answer"
				page.should have_selector('#error_explanation')
			end
		end
	end
end