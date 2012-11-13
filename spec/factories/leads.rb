# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :lead do
    name    "Jesse Flores"
    role    "Administrator"
    school  "Holy Spirit Catholic School"
    email   "Jesse@hsp.org"
    phone   "555-555-555"
  end
end
