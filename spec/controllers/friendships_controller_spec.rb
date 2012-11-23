require 'spec_helper'

describe FriendshipsController do
	
	it "should have proper routes" do
		{:get => "/friendships/" }.should be_routable
    {:post => "/friendships/1/add" }.should be_routable
    {:post => "/friendships/1/accept" }.should be_routable
    {:delete => "/friendships/1" }.should be_routable
    {:get => "/friendships/1/add" }.should_not be_routable
    {:get => "/friendships/1/accept" }.should_not be_routable
    {:get => "/friendships/new" }.should_not be_routable
    {:get => "/friendships/edit" }.should_not be_routable    
  end

end
