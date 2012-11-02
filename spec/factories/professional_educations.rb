# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :professional_education do
    school_name "MyString"
    degree "MyString"
    field_of_study "MyString"
    enroll_date "MyString"
    graduation_date "MyString"
    additional_notes "MyText"
  end
end
