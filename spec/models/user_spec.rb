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
#  role                   :string(255)
#  first_name             :string(255)
#  last_name              :string(255)
#  institution            :string(255)
#  image_file_name        :string(255)
#  image_content_type     :string(255)
#  image_file_size        :integer
#  image_updated_at       :datetime
#  profile_summary        :text
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

  context "When creating a course" do
    let(:user){FactoryGirl.build(:user)}

    describe "User can create a course" do
      before{@course = user.courses.build(course_name:"Physics", course_semester:"Fall", course_year:2012, course_summary:"Summary", :grade => FactoryGirl.create(:grade))}
      it {expect{user.save!}.to change{Course.count}.by(1)}
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

end
