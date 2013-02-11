class FollowingMailer < ActionMailer::Base
  default from: "no-reply@swibat.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.following_mailer.being_followed.subject
  #
  def being_followed(user, followee)
    @follower = followee
    @followed = user
    @greeting = "Hi"

    mail to: @followed.email
  end
end
