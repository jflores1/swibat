# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    sequence(:email)      {|n| "user#{n}@swibat.com"}
    password              "password"
    password_confirmation "password"
    role                  "teacher"
    first_name            "Jesse"
    last_name             "Flores"
    profile_summary				"My profile summary"
  end

  factory :user_with_profile, parent: :user do
    association :institution, name: "School"

    after(:create) do |user|
      user.professional_educations.create(school_name: "My College", degree: "Math", field_of_study: "Math", enroll_date: "May 2005", graduation_date: "May 2007")
      user.professional_accomplishments.create(name: "Prestigious", accomplishment_type: "Award")
      user.links.create(link_type: "twitter", url: "@twitter")
    end
  end
end

