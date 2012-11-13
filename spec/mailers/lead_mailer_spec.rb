require "spec_helper"

describe LeadMailer do
  describe "new_lead" do
    let(:mail) { LeadMailer.new_lead }

    it "renders the headers" do
      mail.subject.should eq("New lead")
      mail.to.should eq(["to@example.org"])
      mail.from.should eq(["from@example.com"])
    end

    it "renders the body" do
      mail.body.encoded.should match("Hi")
    end
  end

end
