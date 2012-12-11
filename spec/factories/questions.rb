# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :question do
    title "Question title"
    text "question text"
    user_id 1
  end
end
