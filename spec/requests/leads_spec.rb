require 'spec_helper'

describe "Leads" do
  subject { page }

  context "Working Route" do
    describe "request-trial path" do
      it "gets the request-trial path" do
        get request_trial_path
        response.status.should be(200)
      end
    end
  end

  context "Valid Form" do
    before {visit request_trial_path}

    describe "it has a form on the page" do
      it {should have_selector("form")}
    end

    describe "a working form" do
      let(:submit){ "Request Access!"}

      describe "with valid information" do
        before do
          fill_in "name",               with: "Jesse Flores"
          select  "Teacher"
          fill_in "school",             with: "Holy Spirit Prep"
          fill_in "email",              with: "jesse@test.com"
        end

        it "should create a lead" do
          expect {click_button submit}.to change{Lead.count}.by(1)
        end
      end

    end

    context "The Request Invite page" do
      before {visit request_invite_path}
      it "should create a lead" do
        find_link("Request Access").click
        fill_in "name",               with: "Jesse Flores"
        select  "Teacher"
        fill_in "school",             with: "Holy Spirit Prep"
        fill_in "email",              with: "jesse@test.com"
        expect{click_button "Request Access!"}.to change(Lead, :count).by(1)
      end
    end 

  end
end
