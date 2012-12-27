namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    User.create!(
    email:                 "teacher@swibat.com",
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

    users = User.all(limit: 6)
    3.times do
      course_name = Faker::Lorem.words(num=4, supplemental = false)
      course_semester = "Fall"
      course_year = 2012
      course_summary = Faker::Lorem.paragraph(sentence_count = 3)
      users.each do |user|
        user.courses.create!(
            course_name: course_name,
            course_semester: course_semester,
            course_year: course_year,
            course_summary: course_summary,
            grade_id: 10
        )
      end
    end

    courses = Course.all(limit: 10)
    5.times do
      objective = Faker::Lorem.sentence(word_count = 6)
      unit_title = Faker::Lorem.words(num = 5)
      expected_start_date = "2012-12-01"
      expected_end_date = "2012-12-10"
      prior_knowledge = Faker::Lorem.sentence(word_count = 6)
      unit_status = "Pending"
      courses.each do |course|
        course.objectives.create!(
            objective: objective
        )
        course.units.create!(
            unit_title: unit_title,
            expected_start_date: expected_start_date,
            expected_end_date: expected_end_date,
            prior_knowledge: prior_knowledge,
            unit_status: unit_status
        )
      end
    end

    units = Unit.all(limit: 10)
    5.times do
      objective = Faker::Lorem.sentence(word_count = 6)
      lesson_title = Faker::Lorem.sentence(word_count = 6)
      lesson_start_date = "2012-12-01"
      lesson_end_date = "2012-12-10"
      lesson_status = "Not Yet Started"
      prior_knowledge = Faker::Lorem.sentence(word_count = 6)
      units.each do |unit|
        unit.objectives.create!(
            objective: objective
        )
        unit.lessons.create!(
            lesson_title: lesson_title,
            lesson_start_date: lesson_start_date,
            lesson_end_date: lesson_end_date,
            lesson_status: lesson_status,
            prior_knowledge: prior_knowledge
        )
      end
    end

    lesson = Lesson.all(limit: 10)
    5.times do
      objective = Faker::Lorem.sentence(word_count = 6)
      lesson.each do |lesson|
        lesson.objectives.create!(
            objective: objective
        )
      end
    end
  end
end
