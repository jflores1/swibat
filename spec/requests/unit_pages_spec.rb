require 'spec_helper'

describe "UnitPages" do
  let(:user){create(:user)}
  let(:course){create(:course, user: user)}

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
      let(:units){course.units}
      let(:unit){create(:unit, course: course)}

      context "with valid information" do
        before {sign_in_and_go_to_form}
        it "saves and returns to user profile page" do
          expect {
            fill_out_form_with_valid_information
            click_button submit
          }.to change(Unit, :count).by(1)
          current_path.should eq(course_path(course))
        end

        it "saves and goes to the lesson page" do
          expect {
            fill_out_form_with_valid_information
            click_button move_on
          }.to change(Unit, :count).by(1)
          current_path.should eq(new_unit_lesson_path(Unit.last))
        end

        it "has at least one objective" do
          expect {
            fill_out_form_with_valid_information
            click_button submit
          }.to change(Unit, :count).by(1)
          Unit.last.objectives.count.should == 1
        end

        it "has at least one assessment" do
          expect {
            fill_out_form_with_valid_information
            click_button submit
          }.to change(Unit, :count).by(1)
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

    describe "Can update a unit" do
      let(:course){create(:course)}
      let(:unit){create(:unit)}
      before do
        sign_in_via_form
        visit edit_course_unit_path(course, unit)
      end
      it "updates the unit" do
        fill_in "unit_title", with: "A different title"
        click_button "Save and Come Back Later"
        page.should have_content("A different title")
      end
    end

  end

  context "When a user is not signed in" do
    describe "it cannot add a new unit" do
      before {get new_course_unit_path(course)}
      it {response.status.should be(302)}
    end
  end

  context "The unit show path" do
    let(:user){create(:user)}
    let(:course){create(:course, user: user)}
    let(:unit){create(:unit_with_lessons, course: course)}
    let!(:objective){unit.objectives.create(objective: "Describe how Carnegie changed steel", objective_type: "Content")}
    let!(:objective2){unit.objectives.create(objective:"Describe how Rockefeller changed oil", objective_type: "Skill")}
    let!(:assessment){unit.assessments.create(assessment_name:"A business plan for the 21st century")}

    before do
      sign_in_via_form
      visit course_unit_path(course, unit)
    end
    subject {page}

    #header information
    it {should have_selector("p", text: "#{unit.expected_start_date.strftime('%B %d')} - #{unit.expected_end_date.strftime('%B %d, %Y')}")}
    it {should have_selector("h2", text: "Physics / The Industrial Revolution")}

    #Standards Met
    xit {should have_content("standards")}

    #Content Covered
    it {should have_content("Describe how Carnegie changed steel")}

    #Skills Covered
    it {should have_content("Describe how Rockefeller changed oil")}

    it "should have a link to edit the unit" do
      find("a.edit-course-unit").click
      current_path.should eq(edit_course_unit_path(course, unit))
    end
    it "should have a link back to the parent course" do
      find_link("Physics").click
      current_path.should eq(course_path(course))
    end

    #lists assessments
    it {should have_selector("h3", text: "Assessments")}
    it {should have_selector("li", text: "A business plan for the 21st century")}

    #lists unit lessons, with links
    it {should have_selector("h3", text: "Unit Lessons")}
    it {should have_content("#{unit.lessons.first.lesson_title}")}
    it "should have a link to the unit lesson page" do
      find_link("#{unit.lessons.first.lesson_title}").click
      page.should have_selector("h2", text: "#{unit.lessons.first.lesson_title}")
    end

    context "for the owning user" do 
      let(:course){create(:course)}
      let(:unit){create(:unit)}
      let(:user){unit.user}

      before do
        visit course_unit_path(course, unit)
      end

      it "displays the assessment form", js: true do
        find("a.add-unit-assessment").click
        page.should have_selector("form#new_assessment")
      end
      it "allows the user to add an assessment", js: true do
        expect{
        find("a.add-unit-assessment").click
        fill_in "assessment_assessment_name", with: "Some text"
        click_button "Add"
        }.to change(Assessment, :count).by(1)
        page.should have_content("Some text")
      end
      it "allows the user to delete an assessment", js: true do
        expect{first('.delete-assessment').click}.to change(Assessment, :count).by(-1)
      end

      it "allows the user to add content objectives", js: true do
        find('a.add-content-objective').click
        page.should have_selector("form#new_objective")
      end

      it "can add a content objective", js: true do
        expect{
          find('a.add-content-objective').click
          fill_in "objective_objective", with: "Content objective"
          click_button "Add"
        }.to change(Objective, :count).by(1)
        page.should have_content("Content objective")
      end

      it "can remove a content objective", js: true do
        expect{
          first('.delete-objective').click
        }.to change(Objective, :count).by(-1)
        page.should_not have_content("Describe how Carnegie changed steel")
      end

      it "can has a skill objective form", js: true do
        find('a.add-skill-objective').click
        page.should have_selector('form#new_objective')
      end

      it "can add a skill objective", js: true do
        expect{
          find('a.add-skill-objective').click
          fill_in "objective_objective", with: "Skill Objective"
          click_button "Add"
        }.to change(Objective, :count).by(1)
        page.should have_content("Skill Objective")
      end
    end

    describe "Displays similar units" do
      it {should have_content("Similar Units")}
    end

    #describe "Working vote model" do
    #  it "should display the voting buttons" do
    #    page.should have_selector(".vote")
    #  end
    #
    #  it "should have working upvote button" do
    #    unit.reputation_for(:votes).to_i.should == 0
    #    upvote = find(".upvote").first(:xpath,".//..")
    #    upvote.click
    #    unit.reputation_for(:votes).to_i.should == 1
    #  end
    #
    #  it "clicking the upvote button should change its color and type param" do
    #    upvote = find(".upvote").first(:xpath,".//..")
    #    upvote.click
    #    page.should have_selector(".upvote-active")
    #    have_xpath("//a[contains(@href,'type=clear')]")
    #  end
    #
    #  it "clicking a red upvote button should reset the user's vote for that resource" do
    #    upvote = find(".upvote").first(:xpath,".//..")
    #    upvote.click
    #    unit.reputation_for(:votes).to_i.should == 1
    #    upvote = find(".upvote-active").first(:xpath,".//..")
    #    upvote.click
    #    unit.reputation_for(:votes).to_i.should == 0
    #  end
    #
    #  it "should have working downvote button" do
    #    unit.reputation_for(:votes).to_i.should == 0
    #    downvote = find(".downvote").first(:xpath,".//..")
    #    downvote.click
    #    unit.reputation_for(:votes).to_i.should == -1
    #  end
    #
    #  it "clicking the downvote button should change its color and type param" do
    #    downvote = find(".downvote").first(:xpath,".//..")
    #    downvote.click
    #    page.should have_selector(".downvote-active")
    #    have_xpath("//a[contains(@href,'type=clear')]")
    #  end
    #
    #  it "clicking a red downvote button should reset the user's vote for that resource" do
    #    downvote = find(".downvote").first(:xpath,".//..")
    #    downvote.click
    #    unit.reputation_for(:votes).to_i.should == -1
    #    downvote = find(".downvote-active").first(:xpath,".//..")
    #    downvote.click
    #    unit.reputation_for(:votes).to_i.should == 0
    #  end
    #end
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
