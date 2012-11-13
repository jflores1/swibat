class LeadMailer < ActionMailer::Base
  default from: "jesse@swibat.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.lead_mailer.new_lead.subject
  #
  def new_lead(lead)
    @greeting = "Hi"
    @lead = lead

    mail to: "jesse.flores@me.com", subject: "New Lead"
  end
end
