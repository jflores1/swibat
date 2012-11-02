# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :professional_experience do
    title "MyString"
    location "MyString"
    description "MyText"
    still_work false
    work_start_month "MyString"
    work_start_year 1
    work_end_month "MyString"
    work_end_year 1
  end
end
