class InvitationsController < ApplicationController
	
	def send_invitation
		emails = params[:emails]
		from = params[:from]
		message = params[:message]

		email_list = emails.split(/[,\s]+/)
		email_list = email_list.collect { |email| email.strip }

		email_list.each do |address|			
			InvitationsMailer.invitation(address, from, message).deliver
		end
	end

end
