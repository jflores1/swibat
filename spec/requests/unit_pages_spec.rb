require 'spec_helper'

describe "UnitPages" do
  let(:course){FactoryGirl.create(:course)}

  context "When a user is signed in" do
    describe "it allows access" do
      before do
        sign_in_as_a_valid_user
        get new_course_unit_path(course)
      end
      it {response.status.should be(200)}
    end

    describe "Can add a unit" do
      let(:submit){"Save and Come Back Later"}
      let(:move_on){"Add Some Lessons"}
      let(:unit){course.units}


      context "with valid information" do
        before {sign_in_and_go_to_form}
        it "saves and returns to user profile page" do
          expect {
            fill_out_form_with_valid_information
            click_button submit
          }.to change(unit, :count).by(1)
          current_path.should eq(course_path(course))
        end

        it "saves and goes to the lesson page" do
          expect {
            fill_out_form_with_valid_information
            click_button move_on
          }.to change(unit, :count).by(1)
          current_path.should == new_unit_lesson_path(1)
        end

        it "has at least one objective" do
          expect {
            fill_out_form_with_valid_information
            click_button submit
          }.to change(unit, :count).by(1)
          Unit.last.objectives.count.should == 1
        end

        it "has at least one assessment" do
          expect {
            fill_out_form_with_valid_information
            click_button submit
          }.to change(unit, :count).by(1)
          Unit.last.assessments.count.should == 1
        end
      end

      context "With invalid information" do
        before {sign_in_and_go_to_form}
        it "does not create a unit" do
          expect {
            fill_out_form_with_invalid_information
            click_button submit
          }.to_not change(unit, :count).by(1)
        end
        it {current_path.should == new_course_unit_path(course)}
      end
    end

    describe "Can navigate to unit show path" do
      let(:unit){create(:unit_with_lessons)}
      let(:user){course.user}
      let!(:objective){unit.objectives.create(objective: "Describe how Carnegie changed steel")}
      let!(:objective2){unit.objectives.create(objective:"Describe how Rockefeller changed oil")}
      let!(:assessment){unit.assessments.create(assessment_name:"A business plan for the 21st century")}

      before do
        sign_in_via_form
        visit course_unit_path(course, unit)
      end
      subject {page}

      #header information
      it {should have_selector("h2", text: "Physics")}
      it {should have_selector("h2",text: "The Industrial Revolution")}
      it {should have_selector("h2", text: "Prior Knowledge")}
      it {should have_selector("p", text: "The Great Barons")}

      #lists objectives. Pluralize "Objective" and "Assessment" based on count
      it {should have_selector("h2", text: "Unit Objectives")}
      it {should have_selector("li", text:"Describe how Carnegie changed steel")}
      it {should have_selector("li", text:"Describe how Rockefeller changed oil")}

      #lists assessments, Pluralized based on count
      it {should have_selector("h2", text: "Unit Assessment")}
      it {should have_selector("li", text: "A business plan for the 21st century")}

      #displays lesson accordion
      it {should have_selector("h2", text: "Lessons")}
      it "should have lesson titles" do
        page.should have_content("Gilded Age")
      end

      describe "Vote div" do
        it "should display the voting buttons" do
          page.should have_selector(".vote")
        end

        it "should have working upvote button" do
          unit.reputation_for(:votes).to_i.should == 0
          upvote = find(".upvote").first(:xpath,".//..")        
          upvote.click
          unit.reputation_for(:votes).to_i.should == 1
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
          unit.reputation_for(:votes).to_i.should == 1
          upvote = find(".upvote-active").first(:xpath,".//..")
          upvote.click
          unit.reputation_for(:votes).to_i.should == 0
        end

        it "should have working downvote button" do
          unit.reputation_for(:votes).to_i.should == 0
          downvote = find(".downvote").first(:xpath,".//..")                
          downvote.click
          unit.reputation_for(:votes).to_i.should == -1
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
          unit.reputation_for(:votes).to_i.should == -1
          downvote = find(".downvote-active").first(:xpath,".//..")
          downvote.click
          unit.reputation_for(:votes).to_i.should == 0
        end
      end
    end

  end

  context "When a user is not signed in" do
    describe "it cannot add a new unit" do
      before {get new_course_unit_path(course)}
      it {response.status.should be(302)}
    end
  end

  private
  def sign_in_and_go_to_form
    sign_in_via_form
    visit new_course_unit_path(course)
  end

  def fill_out_form_with_valid_information
    fill_in "unit_title",           with: "A New Unit"
    fill_in "unit_expected_start_date",  with: "2013/01/01"
    fill_in "unit_expected_end_date",    with: "2013/01/10"
    fill_in "prior_knowledge",      with: ""
    #fill_in "unit_status",          with: "Pending"
    fill_in 'unit_objectives_attributes_0_objective',               with: "An objective"
    fill_in 'unit_assessments_attributes_0_assessment_name',        with: "An assessment"
  end

  def fill_out_form_with_invalid_information
    fill_in "unit_title",           with: "A New Unit"
    fill_in "unit_expected_start_date",  with: "2013/01/10"
    fill_in "unit_expected_end_date",    with: "2013/01/01"
    fill_in "prior_knowledge",      with: ""
    #fill_in "unit_status",          with: "Invalid Status"
  end

end
