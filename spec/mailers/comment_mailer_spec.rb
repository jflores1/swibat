require "spec_helper"

describe CommentMailer do
  describe "new_comment_notification" do
    let(:mail) { CommentMailer.new_comment_notification }

    it "renders the headers" do
      mail.subject.should eq("New comment notification")
      mail.to.should eq(["to@example.org"])
      mail.from.should eq(["from@example.com"])
    end

    it "renders the body" do
      mail.body.encoded.should match("Hi")
    end
  end

end
