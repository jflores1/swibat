FactoryGirl.define do

  factory :course do
    course_name "Physics"
    course_semester "Fall"
    course_year 2012
    course_summary  "This is a course summary."
  end

  factory :unit do
    unit_title  "The Industrial Revolution"
    expected_start_date  Date.new(2012, 12, 12)
    expected_end_date    Date.new(2012, 12, 15)
    prior_knowledge     "None"
    unit_status         "Started"
    course_id           1
  end

  factory :lesson do
    lesson_title        "This is a title"
    lesson_start_date   Date.new(2012, 12, 12)
    lesson_end_date     Date.new(2012, 12, 15)
    lesson_status       "Started"
  end

end