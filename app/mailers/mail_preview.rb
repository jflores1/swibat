# class MailPreview < MailView

# 	def signup_confirmation
# 		user = User.create!(first_name:"Test", last_name:"User", email:"test_user@mail.com", password: "password", password_confirmation:"password", role:"teacher")
# 		mail = UserMailer.signup_confirmation(user)
# 		user.destroy
# 		mail
# 	end

# end