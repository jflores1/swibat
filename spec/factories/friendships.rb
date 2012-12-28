# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :friendship do
    # first_user FactoryGirl.create(:user)
    # second_user FactoryGirl.create(:user, {:email => "marjan.georgiev@gmail.com", :first_name => "marjan", :last_name => "georgiev"})
    user_id 1
    friend_id 2
    status "accepted"
  end
end
