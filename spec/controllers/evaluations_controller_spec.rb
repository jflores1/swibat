require 'spec_helper'

describe EvaluationsController do

  describe "GET 'template'" do
    it "returns http success" do
      get 'template'
      response.should be_success
    end
  end

end
