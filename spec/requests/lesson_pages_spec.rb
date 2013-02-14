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

    context "The Lesson Show Page" do
      describe "a user not signed in" do
        let(:user){create(:user)}
        let(:course){create(:course, user: user)}
        let(:unit){create(:unit, course: course)}
        let(:lesson){create(:lesson, unit: unit)}

        before {visit unit_lesson_path(unit, lesson)}

        it {page.should have_content(lesson.lesson_title)}
        it {page.should have_content(lesson.user.full_name)}
        it {page.should have_content(lesson.lesson_start_date.strftime("%B %d"))}
        it {page.should have_content(lesson.lesson_end_date.strftime("%B %d, %Y"))}

        #shows assessments
        describe "it shows assessments" do
          before {lesson.assessments.create(assessment_name: "Assessment")}
          it {page.should have_content("Assessment")}
        end

        describe "it shows content objectives" do
          before {lesson.objectives.create(objective: "Content Objective", objective_type: "Content")}
          it {page.should have_content("Content Objective")}
        end

        describe "it shows skill objectives" do
          before {lesson.objectives.create(objective: "Skill Objective", objective_type: "Skill")}
          it {page.should have_content("Skill Objective")}
        end

        describe "videos icon" do
          it "displays a videos icon when there are videos" do
            lesson.videos.create(yt_video_id: "ID", description: "description", title: "Title", is_complete: true)
            visit unit_lesson_path(unit, lesson)
            page.should have_xpath("//i[@class='icon-film']")
          end

          it "does not display a videos icon when there are no videos" do
            page.should_not have_xpath("//i[@class='icon-film']")
          end
        end


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
