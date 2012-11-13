# == Schema Information
#
# Table name: leads
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  role       :string(255)
#  school     :string(255)
#  email      :string(255)
#  phone      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe Lead do

  let(:lead) {Lead.new(name: "Jesse Flores", role: "Principal", school: "ABC Catholic School", email: "email@test.com", phone: "123-456-7890")}
  subject { lead }

  describe "appropriate accessor methods" do
    it {should respond_to(:name)}
    it {should respond_to(:role)}
    it {should respond_to(:school)}
    it {should respond_to(:email)}
    it {should respond_to(:phone)}
  end

  context "with invalid information" do
    describe "- it's missing a name" do
      before {lead.name = " "}
      it {should_not be_valid}
      it {expect {lead.save!}.to raise_error(ActiveRecord::RecordInvalid)}
    end

    describe "it's missing a role" do
      before {lead.role = " "}
      it {should_not be_valid}
      it {expect {lead.save!}.to raise_error(ActiveRecord::RecordInvalid)}
    end

    describe "it's got an invalid role" do
      before {lead.role = "Doofus"}
      it {should_not be_valid}
      it {expect {lead.save!}.to raise_error(ActiveRecord::RecordInvalid)}
    end

    describe "- it's missing a school" do
      before {lead.school = " "}
      it {should_not be_valid}
      it {expect {lead.save!}.to raise_error(ActiveRecord::RecordInvalid)}
    end

    describe "- it's missing an email address" do
      before {lead.email = " "}
      it {should_not be_valid}
      it {expect {lead.save!}.to raise_error(ActiveRecord::RecordInvalid)}
    end

    describe "- the email address is missing the suffix" do
      before {lead.email = "jesse"}
      it {should_not be_valid}
      it {expect {lead.save!}.to raise_error(ActiveRecord::RecordInvalid)}
    end

    describe "- the phone number is too short" do
      before {lead.phone = "a"*6}
      it {should_not be_valid}
      it {expect {lead.save!}.to raise_error(ActiveRecord::RecordInvalid)}
    end

    describe "- the phone number is too long" do
      before {lead.phone = "a"*14}
      it {should_not be_valid}
      it {expect {lead.save!}.to raise_error(ActiveRecord::RecordInvalid)}
    end

    describe "- it's missing a phone number" do
      before {lead.phone = " "}
      it {should_not be_valid}
      it {expect {lead.save!}.to raise_error(ActiveRecord::RecordInvalid)}
    end
  end

  context "with valid information" do
    describe "- teacher is a valid role" do
      before {lead.role = "teacher"}
      it {should be_valid}
    end

    describe "- role is not case sensitive" do
      before {lead.role = "Teacher"}
      it {should be_valid}
    end

    describe "- administrator is a valid role" do
      before {lead.role = "administrator"}
      it {should be_valid}
    end
  end

  context "It sends emails" do
    describe "When a new lead is entered" do
      it "sends us a notification" do
        lead = FactoryGirl.create(:lead)
        last_email.to.should include("jesse.flores@me.com")
      end
    end

  end
end
