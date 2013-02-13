# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :video do
    title "Video Title"
    description "A description of the video"
    address "MyString"
  end
end
