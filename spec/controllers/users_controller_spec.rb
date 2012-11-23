require 'spec_helper'

describe UsersController do
	before do		
		@marjan = FactoryGirl.create(:user, {:email => 'marjan@test.com', :first_name => "marjan", :last_name => "georgiev"})
		login_user
	end

	describe "show" do
		it "can view other profiles" do
			visit_user_path(@marjan)
			response.response.should be_success
		end
	end
end
