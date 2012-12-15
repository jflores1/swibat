# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :grade do
    sequence(:grade_level) {|n| "Grade #{n}"}
  end


end
