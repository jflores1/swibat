# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :activity do
    activity  "Lecture"
    duration  "15 minutes"
    agent     "Teacher"
  end
end
