namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    User.create!(
    email:                 "jesse@test3.com",
    password:              "password",
    password_confirmation: "password",
    role:                  "teacher",
    first_name:            "Jesse",
    last_name:             "Flores",
    institution:           "Some School"
    )

    99.times do |n|
      email = "example-#{n+1}@test.com"
      password = "password"
      first_name = Faker::Name.first_name
      last_name = Faker::Name.last_name
      role = "teacher"
      institution = Faker::Company.name
      User.create!(
          email: email,
          password: password,
          password_confirmation: password,
          role: role,
          first_name: first_name,
          last_name: last_name,
          institution: institution
      )
    end
  end
end