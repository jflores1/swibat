FactoryGirl.define do

  factory :course do
    course_name         "Physics"
    course_semester     "Fall"
    course_year         2012
    course_summary      "This is a course summary."
    association :user, factory: :user
    association :grade, factory: :grade, grade_level:"Grade 1"
    association :subject, factory: :subject, subject: "Science"

    factory :course_with_units do
      after(:create) do |c|
        FactoryGirl.create(:unit, course: c)
      end
    end
  end

  factory :unit do
    unit_title  "The Industrial Revolution"
    expected_start_date  Date.new(2012, 12, 12)
    expected_end_date    Date.new(2012, 12, 15)
    prior_knowledge     "The Great Barons"
    unit_status         "Started"
    course_id           1

    factory :unit_with_lessons do
      after(:create) do |u|
        FactoryGirl.create(:lesson, unit: u)
      end
    end

  end

  factory :lesson do
    lesson_title        "The End of the Gilded Age"
    prior_knowledge     "The end of Antebellum era"
    lesson_start_date   Date.new(2012, 12, 12)
    lesson_end_date     Date.new(2012, 12, 15)
    lesson_status       "Started"
    end

  factory :objective do
    objective           "Measure average velocity of Sparrow's wing speed"
    objective_type      "Goal"
  end


end