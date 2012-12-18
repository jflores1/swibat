# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :flag do
    flaggable_id 1
    flaggable_type "MyString"
    user_id 1
  end
end
