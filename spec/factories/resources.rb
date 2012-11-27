# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :resource do
    name "MyString"
    description "MyText"
    upload File.new(Rails.root + 'spec/fixtures/files/upload.txt')
  end
end
