# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :evaluation_criterion do
    contents "MyString"
    evaluation_domain_id 1
  end
end
