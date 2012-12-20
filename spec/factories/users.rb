# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    sequence(:email)      {|n| "user#{n}@swibat.com"}
    password              "password"
    password_confirmation "password"
    role                  "teacher"
    first_name            "Jesse"
    last_name             "Flores"
    institution           "Some School"
    profile_summary				"My profile summary"    
  end
end

