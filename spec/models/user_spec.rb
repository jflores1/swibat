# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0)
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  role                   :string(255)      default("teacher")
#  first_name             :string(255)
#  last_name              :string(255)
#  institution            :string(255)
#  image_file_name        :string(255)
#  image_content_type     :string(255)
#  image_file_size        :integer
#  image_updated_at       :datetime
#  profile_summary        :text
#  provider               :string(255)
#  uid                    :string(255)
#

require 'spec_helper'
require "cancan/matchers"

describe User do

  let(:user){FactoryGirl.build(:user)}
  subject {user}
  it {should respond_to(:role)}
  it {should respond_to(:first_name)}
  it {should respond_to(:last_name)}
  it {should respond_to(:institution)}
  it {should respond_to(:questions)}
  it {should respond_to(:answers)}
  it {should respond_to(:flags)}
  it {should respond_to(:microposts)}
  it {should respond_to(:feed)}
  it {should respond_to(:followings)}#relationships
  it {should respond_to(:people_followed)}#followed_users
  it {should respond_to(:incoming_followings)}#reverse relationships
  it {should respond_to(:followers)}

  context "Has validation on non-devise columns" do
    describe "When missing first name" do
      before {user.first_name = ""}
      it {should_not be_valid}
      it {expect {user.save!}.to raise_error(ActiveRecord::RecordInvalid)}
    end

    describe "When missing last name" do
      before {user.last_name = ""}
      it {should_not be_valid}
      it {expect {user.save!}.to raise_error(ActiveRecord::RecordInvalid)}
    end

    describe "When missing institution" do
      before {user.institution = ""}
      it {should_not be_valid}
      it {expect {user.save!}.to raise_error(ActiveRecord::RecordInvalid)}
    end

    describe "When has an invalid role" do
      before {user.role = "invalid_role"}
      it {should_not be_valid}
      it {expect {user.save!}.to raise_error(ActiveRecord::RecordInvalid)}
    end

    describe "When has a valid role" do
      before {user.role = "school_admin"}
      it {should be_valid}
    end

    context "Profile Summary" do
      describe "when profile summary is blank" do
        before {user.profile_summary = ""}
        it {should be_valid}
        it {expect {user.save!}.to_not raise_error(ActiveRecord::RecordInvalid)}
      end

      describe "when profile summary is too long" do
        before {user.profile_summary = "a"*200}
        it {should_not be_valid}
        it {expect {user.save!}.to raise_error(ActiveRecord::RecordInvalid)}
      end
    end
  end

  describe "following" do
    let(:user){build(:user)}
    let(:other_user){create(:user)}
    
    before do
      user.save
      user.follow!(other_user)
    end

    it {should be_following(other_user)}
    its(:people_followed){should include(other_user)}

    describe "followed user" do
      subject {other_user}
      its(:followers){should include(user)}
    end

    describe "and unfollowing" do
      before {user.unfollow!(other_user)}
      it {should_not be_following(other_user)}
      its(:people_followed) {should_not include(other_user)}
    end
  end

  context "micropost associations" do
    let(:user){build(:user)}
    before {user.save}
    let(:older_micropost){create(:micropost, user: user, created_at: 1.day.ago)}
    let(:new_micropost){create(:micropost, user: user, created_at: 1.hour.ago)}

    describe "status" do
      let(:unfollowed_post){create(:micropost, user: create(:user))}
      let(:followed_user){create(:user)}


      before do
        user.follow!(followed_user)
        3.times {followed_user.microposts.create!(content:"Lorem Ipsum")}
      end

      its(:feed){should include(new_micropost)}
      its(:feed){should include(older_micropost)}
      its(:feed){should_not include(unfollowed_post)}
      its(:feed) do
        followed_user.microposts.each do |micropost|
          should include(micropost)
        end
      end
    end
  end

  context "Authorization" do 
    let(:user){FactoryGirl.create(:user)}
    let(:other_user){FactoryGirl.create(:user, :email => "marjan@test.com", :first_name => "marjan", :last_name => "georgiev")}
    
    it "should allow me to update my own profile" do
      ability = Ability.new(user)
      ability.should be_able_to(:update, user)
    end

    it "should not allow me to update other people's profiles" do
      ability = Ability.new(user)
      ability.should_not be_able_to(:update, other_user)
    end

  end

  context "Automated Email" do
    describe "When a new user is created" do
      it "sends the user a notification" do
        user = create(:user, email:"jesse@swibat.com")
        last_email.to.should include("jesse@swibat.com")
      end
    end
  end

end
