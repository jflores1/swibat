# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :professional_accomplishment do
    accomplishment_type "Certification"
    name "MyString"
    year 1
  end
end
