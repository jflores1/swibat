require 'spec_helper'
include Warden::Test::Helpers
Warden.test_mode!

describe "CoursePages" do
  context "Accessing the new user course page" do
    describe "An authorized user tries to get access" do
      it "should allow access" do
        sign_in_user_and_go_to_page
        response.status.should be(200)
      end
    end

    describe "An unauthorized user tries to get access" do
      it "should not allow access" do
        get new_course_path
        response.status.should be(302)
      end
    end
  end

  describe "A Working Form" do
    let(:user){build_stubbed(:user)}
    let(:course){build_stubbed(:course, user: user)}
    before do
      sign_in_via_form
      FactoryGirl.create_list(:grade, 14)
      FactoryGirl.create_list(:subject, 5)
      visit new_course_path
    end
    after(:each) do
      FactoryGirl.reload
    end
    let(:unit_button){"Create a Unit"}
    let(:save_button){"Save and Return"}

    describe "There is a form on the page" do
      it {page.should have_selector("form")}
    end

    context "With valid information" do
      it "adds a course" do
        expect {
          fill_out_course_form_with_valid_info
          click_button save_button
        }.to change(Course, :count).by(1)
        current_path.should == course_path(Course.last)
      end

      it "Allows a user to save a course and go the Unit page" do
        expect {
          fill_out_course_form_with_valid_info
          click_button unit_button
        }.to change(Course, :count).by(1)
        page.should have_selector("form")
      end
    end

    context "With invalid information" do
      it "Does not add a save an invalid course for the user" do
        expect {
          fill_out_course_form_with_invalid_info
          click_button save_button
        }.to_not change(Course, :count).by(1)
        invalid_form_expectations
      end

      it "Does not allow a user to go to a unit page with an invalid course" do
        expect {
          fill_out_course_form_with_invalid_info
          click_button unit_button
        }.to_not change(Course, :count).by(1)
        invalid_form_expectations
      end

      it "Displays an error modal" do
        fill_out_course_form_with_invalid_info
        page.should have_selector(".modal")
      end

      xit "Displays error messages to the user" do

      end
    end

  end

  context "The Course/Show Page" do
    context "An unregistered user" do
      let(:user){create(:user)}
      let(:course){create(:course, user: user)}

      before do
        visit course_path(course)
      end

      subject{page}

      describe "Has Course Header Information" do

        it {should have_content("Physics")}
        it {should have_content("Fall")}
        it {should have_content("2012")}
        it {should have_content("Grade 1")}

        it "has a link to the syllabus page" do
          find('a.get-syllabus').click
          current_path.should eq(syllabus_course_path(course))
        end
      end

      describe "Displays similar courses" do
        xit {should have_content("Similar Courses")}
      end

      describe "Presence of Course Summary Information" do
        it {should have_content("Course Summary")}
        it {should have_content("This is a course summary")}
      end

      describe "Presence of Course Objectives" do
        before do
          course.objectives.create(attributes_for(:objective, objective: "objective one", objective_type: "Content"))
          visit course_path(course)
        end
        it {should have_content("Course Goals")}
        it {should have_content("objective one")}
      end

      it {should have_content("Standards Met")}
      it {should have_content("Units")}

      #consider deleting if we don't keep a sidebar.
      describe "The sidebar" do
        xit {page.should have_content("Invite")}
      end

      # describe "Vote div" do
      #   it "should display the voting buttons" do
      #     page.should have_selector(".vote")
      #   end

      #   it "should have working upvote button" do
      #     course.reputation_for(:votes).to_i.should == 0
      #     upvote = find(".upvote").first(:xpath,".//..")        
      #     upvote.click
      #     course.reputation_for(:votes).to_i.should == 1
      #   end

      #   it "clicking the upvote button should change its color and type param" do       
      #     upvote = find(".upvote").first(:xpath,".//..")
      #     upvote.click
      #     page.should have_selector(".upvote-active")
      #     have_xpath("//a[contains(@href,'type=clear')]")
      #   end

      #   it "clicking a red upvote button should reset the user's vote for that resource" do
      #     upvote = find(".upvote").first(:xpath,".//..")
      #     upvote.click
      #     course.reputation_for(:votes).to_i.should == 1
      #     upvote = find(".upvote-active").first(:xpath,".//..")
      #     upvote.click
      #     course.reputation_for(:votes).to_i.should == 0
      #   end

      #   it "should have working downvote button" do
      #     course.reputation_for(:votes).to_i.should == 0
      #     downvote = find(".downvote").first(:xpath,".//..")                
      #     downvote.click
      #     course.reputation_for(:votes).to_i.should == -1
      #   end

      #   it "clicking the downvote button should change its color and type param" do       
      #     downvote = find(".downvote").first(:xpath,".//..")
      #     downvote.click
      #     page.should have_selector(".downvote-active")
      #     have_xpath("//a[contains(@href,'type=clear')]")
      #   end

      #   it "clicking a red downvote button should reset the user's vote for that resource" do
      #     downvote = find(".downvote").first(:xpath,".//..")
      #     downvote.click
      #     course.reputation_for(:votes).to_i.should == -1
      #     downvote = find(".downvote-active").first(:xpath,".//..")
      #     downvote.click
      #     course.reputation_for(:votes).to_i.should == 0
      #   end
      # end

      describe "Presence of Course Summary Information" do
        it {should have_content("Course Summary")}
        it {should have_content("This is a course summary")}
      end

      describe "the user cannot access user restricted actions" do
        xit {page.should_not have_selector('a.add-micropost')}
        it {page.should_not have_selector('.header-edit')}
        it {page.should_not have_selector('.add-course-goal')}
        it {page.should_not have_selector('.delete-goal')}
        it {page.should_not have_selector('#course-add-unit')}
        it {page.should_not have_content("Add one now.")}
      end

      describe "it displays microposts" do
        let(:micropost){create(:micropost, user: user)}
        xit {should have_content("Lorem Ipsum")}
        #TODO: Consider deleting this test if single_page layout ends up being permanent
      end
    end

    context "The owning user" do 
      before do
        sign_in_via_form
        @course = @user.courses.create(attributes_for(:course))
        visit course_path(@course)
      end

      it "has a link to edit the page" do
        find("a.header-edit").click
        current_path.should eq(edit_course_path(@course))
      end

      describe "can add a new goal to the course", js: true do
        it "has a link to add a goal" do
          find('a#add-course-goal').click
          page.should have_selector("form#new_objective")
        end

        it "fills in the form and adds a goal" do
          find('a#add-course-goal').click
          fill_in "objective_objective", with: "goal"
          click_button ("Add")
          page.should have_content("goal")
        end
      end

      describe "can delete goals from the course", js: true do
        let(:objective) {course.objectives.create(objective: "Objective", objective_type: "Goal")}
        it "finds the link and deletes" do
          expect{
            first('.delete-goal').click
          }.to change(Objective, :count).by(-1)
        end
      end

      #TODO: Consider deleting this test if we keep the single page layout
      describe "adding microposts", js: true do
        xit {page.should have_selector("form#new_micropost")}
        xit "adds a micropost" do
          expect {
          fill_in "micropost_content", with: "some content"
          click_button "Post"
          }.to change(Micropost, :count).by(1)
        end
        xit "does not reload the page" do 
          expect {
            fill_in "micropost_content", with: "some content"
            click_button "Post"
          }.to_not change{page.response_headers}
          page.should have_content("some content")
        end
      end
    end
  end

  context "The Course Index Page" do
    let!(:user){create(:user)}
    let!(:course){create(:course, user: user)}
    before(:each) do
      visit courses_path
    end
    it {current_path.should eq(courses_path)}
    it {page.should have_content("All Courses")}
    it {page.should have_content("Physics")}
    it {page.should have_content("This is a course summary.")}
    it {page.should have_content(course.user.full_name)}
  end

  context "The Course Feed" do
    before do
      sign_in_via_form
      visit feed_courses_path
    end
    it {page.should have_content("Feed")}

  end

  context "The Course/syllabus page" do
    let!(:course){create(:course)}
    before(:each) do
      visit syllabus_course_path(course)
    end
    it {page.should have_content(course.course_name)}
    it {page.should have_content(course.grade)}
  end

  describe "The unit calendar page" do
    let(:course){create(:course, user: @user)}
    let(:unit){create(:unit, course: course)}
    before do
      sign_in_via_form      
    end

    context "The Calendar dropdown menu" do
      it "takes the user to the unit calendar page" do
        click_link("calendars")
        click_link("My Courses")
        select("#{course.course_name}")
        current_path.should be(unit_calendar_course_path(course))  
      end      
    end

    context "The Unit Calendar Page" do
      before do
        visit unit_calendar_course_path(course)
      end
      it {page.should have_content(course.course_name)}
      it {page.should have_content(course.user.full_name)}
      it {page.should have_content(Date.today.month)}
      it {page.should have_content(unit.unit_title)}
    end

  end

  private
  def sign_in_user_and_go_to_page
    sign_in_as_a_valid_user
    get new_course_path
  end

  def fill_out_course_form_with_valid_info
    grades = Grade.all
    subject = Subject.all
    fill_in 'course_name',     with: "Physics 1"
    select  'Fall',            from: "course_course_semester"
    select  '2012',            from: "course_course_year"
    select  'Grade 5'
    select  'Subject 5'
    fill_in 'course_summary',  with: "This is a valid course summary."
  end

  def fill_out_course_form_with_invalid_info
    #fill_in 'course_name',     with: "Physics 1"
    select  'Fall',            from: "course_course_semester"
    select  '2012',            from: "course_course_year"
    fill_in 'course_summary',  with: "This is a valid course summary."
  end

  def invalid_form_expectations
    page.should have_content("Sorry")
    page.should have_selector("form")
  end

  def select_second_option(id)
    second_option_xpath = "//*['@id = #{id}']/option[3]"
    second_option = find(:xpath, second_option_xpath).value
    select(second_option, from: id)
  end

  def load_grades
    grades = Grade.all
  end

end
