require 'spec_helper'

describe UsersController do
	before do		
		@marjan = FactoryGirl.create(:user, {:email => 'marjan@test.com', :first_name => "marjan", :last_name => "georgiev"})
		signed_in_as_a_valid_user
	end

	describe "GET 'show'" do
		it "can view other profiles" do
			visit user_path(@marjan)
			response.should be_success
		end
	end
end
