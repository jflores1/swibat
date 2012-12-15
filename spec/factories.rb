FactoryGirl.define do

  factory :course do
    course_name         "Physics"
    course_semester     "Fall"
    course_year         2012
    course_summary      "This is a course summary."
    user_id             1
    association :grade, factory: :grade, grade_level:"Grade 1"
  end

  factory :unit do
    unit_title  "The Industrial Revolution"
    expected_start_date  Date.new(2012, 12, 12)
    expected_end_date    Date.new(2012, 12, 15)
    prior_knowledge     "The Great Barons"
    unit_status         "Started"
    course_id           1

    factory :unit_with_objectives do
      after(:create) do |unit|
        create(:objective, objective: "Describe how Carnegie changed steel", objectiveable_id: unit.id, objectiveable_type:"unit")
      end
    end
  end

  factory :new_unit do
    unit_title  "The Industrial Revolution"
    expected_start_date  Date.new(2012, 12, 12)
    expected_end_date    Date.new(2012, 12, 15)
    prior_knowledge     "None"
  end

  factory :lesson do
    lesson_title        "This is a title"
    lesson_start_date   Date.new(2012, 12, 12)
    lesson_end_date     Date.new(2012, 12, 15)
    lesson_status       "Started"
    unit

  end

  factory :objective do
    objective           "Measure average velocity of Sparrow's wing speed"
  end


end