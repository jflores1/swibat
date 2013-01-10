class InvitationsMailer < ActionMailer::Base
  default from: "feedback@swibat.com"

  def invitation(address, from, message)
    @from = from
    @message = message

    mail to: address, subject: from + " has invited you to join Swibat"
  end

end
