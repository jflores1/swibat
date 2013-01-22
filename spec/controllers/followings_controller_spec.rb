require 'spec_helper'

describe FollowingsController do

  describe "GET 'follow'" do
    it "returns http success" do
      get 'follow'
      response.should be_success
    end
  end

  describe "GET 'destroy'" do
    it "returns http success" do
      get 'destroy'
      response.should be_success
    end
  end

end
