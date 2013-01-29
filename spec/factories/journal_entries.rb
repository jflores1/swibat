# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :journal_entry do
    average_score 1.5
    median_score 1.5
    highest_score 1.5
    lowest_score 1.5
    lesson_pros "MyText"
    lesson_cons "MyText"
  end
end
