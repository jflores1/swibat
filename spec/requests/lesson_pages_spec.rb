require 'spec_helper'

describe "LessonPages" do
  let(:course){create(:course)}
  let(:unit){FactoryGirl.create(:unit, course: course)}

  context "When a user is signed in" do
    describe "It allows access" do
      before do
        sign_in_as_a_valid_user
        get new_unit_lesson_path(unit)
      end
      it {response.status.should be(200)}
    end

    describe "Submits a form to add a lesson" do
      let(:submit){"Submit"}
      let(:add_another_lesson){"Add Another Lesson"}
      let(:lesson){unit.lessons}

      context "With valid attributes" do
        before {
          sign_in_and_go_to_page
        }

        it {page.should have_content(unit.unit_title)}

        context "Without a resource" do
          it "should add a lesson and then another" do
            expect {
              fill_in_form_with_valid_information
              click_button add_another_lesson
            }.to change(lesson, :count).by(1)
            current_path.should == new_unit_lesson_path(unit)
          end

          it "should add a lesson and go back to user page" do
            expect {
              fill_in_form_with_valid_information
              click_button submit
            }.to change(lesson, :count).by(1)
            current_path.should == user_path(@user)
          end

          it "should have at least one objective" do
            expect {
              fill_in_form_with_valid_information
              click_button submit
            }.to change(lesson, :count).by(1)
            Lesson.last.objectives.count.should == 1
          end

          it "should have at least one assessment" do
            expect {
              fill_in_form_with_valid_information
              click_button submit
            }.to change(lesson, :count).by(1)
            Lesson.last.assessments.count.should == 1
          end
        end

        context "With resources" do
          it "should add a lesson with resources" do
            fill_in 'lesson_title',     				with: "My lsson"
            fill_in 'lesson_lesson_start_date', with: "2011-01-01"
            fill_in 'lesson_lesson_end_date',	 	with: "2012-01-01"
            select  "Not Yet Started",          from: "lesson_lesson_status"
            fill_in 'prior_knowledge', 					with: "None"
            fill_in 'lesson_resources_attributes_0_name', 	with: "Lesson notes"
            page.attach_file('lesson_resources_attributes_0_upload', Rails.root + 'spec/fixtures/files/upload.txt')
            expect { click_button submit }.to change(Lesson, :count).by(1)
            Lesson.last.resources.count.should == 1
            resource = Resource.last
            resource.name.should == "Lesson notes"
            resource.upload_file_name.should == "upload.txt"
          end
        end

      end

      context "With invalid attributes" do
        before {sign_in_and_go_to_page}
        it "should not add a lesson" do
          expect {
            fill_in_form_with_invalid_information
            click_button submit
          }.to_not change(lesson, :count).by(1)
        end
        it {current_path.should == new_unit_lesson_path(unit)}

        it "should show errors on invalid submit" do
          click_button submit
          page.should have_selector('#error_explanation')
        end
      end
    end

    context "The Lesson Show page" do
      let(:lesson){create(:lesson, unit: unit)}
      before do
        sign_in_via_form
        visit unit_lesson_path(unit, lesson)
      end

      describe "it shows lesson information" do
        it {page.should have_content("The End of the Gilded Age")}
        it {page.should have_content("The end of Antebellum era")}

        context "lesson missing parts" do
          describe "should prompt to add an objective" do
            it {page.should have_selector("p", text: "No objectives? Boo.")}
            it "should prompt to add an objective" do
              find_link("Add some.").click
              current_path.should eq(edit_unit_lesson_path(unit, lesson))
            end
          end

          describe "should prompt to add an assessment" do
            it {page.should have_selector("p", text:"No assessments? For shame.")}
            it "should prompt to add an assessment" do
              find_link("Add an assessment.").click
              current_path.should eq(edit_unit_lesson_path(unit, lesson))
            end
          end

          describe "should prompt to add resources" do
            it {page.should have_selector("p", text: "The only resource needed here is awesome teaching.")}
            it "should prompt to add a resource" do
              find_link("Add a resource.").click
              current_path.should eq(edit_unit_lesson_path(unit, lesson))
            end
          end
        end

        context "filled out lesson" do
          let!(:objective){lesson.objectives.create(objective:"Describe the important people of the gilded age.")}
          let!(:assessment){lesson.assessments.create(assessment_name:"Quiz")}
          let!(:activity){lesson.activities.create(activity: "Lecture", duration:"15 mins", agent:"Teacher")}
          before(:each) do
            visit unit_lesson_path(unit, lesson)
          end
          it {page.should have_content("Describe the important people")}
          it {page.should have_content("Quiz")}
          it {page.should have_content("Lecture")}
          it {page.should have_content("15 mins")}
          it {page.should have_content("Teacher")}
        end

      end

      describe "it adds activities to the lesson" do
        before {visit unit_lesson_path(unit, lesson)}
        it "should add an activity" do
          expect{
            fill_in "activity_activity",  with: "Activity"
            fill_in "activity_duration",  with: "5 mins"
            select  "Teacher",            from: "activity_agent"
            click_button "Submit"
          }.to change(Activity, :count).by(1)
        end
      end
    end

    describe "Vote div" do
      let(:lesson){FactoryGirl.create(:lesson, :unit => unit)}
      before do  
        sign_in_via_form       
        visit unit_lesson_path unit, lesson
      end

      it "should display the voting buttons" do
        page.should have_selector(".vote")
      end

      it "should have working upvote button" do
        lesson.reputation_for(:votes).to_i.should == 0
        upvote = find(".upvote").first(:xpath,".//..")        
        upvote.click
        lesson.reputation_for(:votes).to_i.should == 1
      end

      it "clicking the upvote button should change its color and type param" do       
        upvote = find(".upvote").first(:xpath,".//..")
        upvote.click
        page.should have_selector(".upvote-active")
        have_xpath("//a[contains(@href,'type=clear')]")
      end

      it "clicking a red upvote button should reset the user's vote for that resource" do
        upvote = find(".upvote").first(:xpath,".//..")
        upvote.click
        lesson.reputation_for(:votes).to_i.should == 1
        upvote = find(".upvote-active").first(:xpath,".//..")
        upvote.click
        lesson.reputation_for(:votes).to_i.should == 0
      end

      it "should have working downvote button" do
        lesson.reputation_for(:votes).to_i.should == 0
        downvote = find(".downvote").first(:xpath,".//..")                
        downvote.click
        lesson.reputation_for(:votes).to_i.should == -1
      end

      it "clicking the downvote button should change its color and type param" do       
        downvote = find(".downvote").first(:xpath,".//..")
        downvote.click
        page.should have_selector(".downvote-active")
        have_xpath("//a[contains(@href,'type=clear')]")
      end

      it "clicking a red downvote button should reset the user's vote for that resource" do
        downvote = find(".downvote").first(:xpath,".//..")
        downvote.click
        lesson.reputation_for(:votes).to_i.should == -1
        downvote = find(".downvote-active").first(:xpath,".//..")
        downvote.click
        lesson.reputation_for(:votes).to_i.should == 0
      end
    end

  end

  context "A user not signed in" do
    it "cannot access the page" do
      get new_unit_lesson_path(unit)
      response.status.should be(302)
    end
  end
    
  private
  def sign_in_and_go_to_page
    sign_in_via_form
    visit new_unit_lesson_path(unit)
  end

  def fill_in_form_with_valid_information
    fill_in "lesson_title",               with: "A new Lesson"
    fill_in "lesson_lesson_start_date",   with: "2013/01/01"
    fill_in "lesson_lesson_end_date",     with: "2013/01/10"
    select  "Not Yet Started",            from: "lesson_lesson_status"
    fill_in "prior_knowledge",            with: "None required"
    fill_in 'lesson_objectives_attributes_0_objective',               with: "An objective"
    fill_in 'lesson_assessments_attributes_0_assessment_name',        with: "An assessment"
  end

  def fill_in_form_with_invalid_information
    fill_in "lesson_title",               with: "A new Lesson"
    fill_in "lesson_lesson_start_date",   with: "2013/01/10"
    fill_in "lesson_lesson_end_date",     with: "2013/01/01"
    select  "Not Yet Started",            from: "lesson_lesson_status"
    fill_in "prior_knowledge",            with: "None required"
  end

end
