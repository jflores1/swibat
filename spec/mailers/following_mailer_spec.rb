require "spec_helper"

describe FollowingMailer do
  describe "being_followed" do
    let(:mail) { FollowingMailer.being_followed }

    it "renders the headers" do
      mail.subject.should eq("Being followed")
      mail.to.should eq(["to@example.org"])
      mail.from.should eq(["from@example.com"])
    end

    it "renders the body" do
      mail.body.encoded.should match("Hi")
    end
  end

end
