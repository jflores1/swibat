# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :profile do
    prefix "MyString"
    first_name "MyString"
    last_name "MyString"
  end
end
