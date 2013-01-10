class CommentMailer < ActionMailer::Base
  default from: "mail@swibat.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.comment_mailer.new_comment_notification.subject
  #
  def new_comment_notification(comment)
    @greeting = "Hi"
    @comment = comment
    @user = comment.commentable.user

    mail to: @user.email
  end
end
