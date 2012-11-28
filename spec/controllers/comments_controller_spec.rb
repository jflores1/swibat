require 'spec_helper'

describe CoursesController do
  login_user
  render_views

  it "should have proper routes" do
    {:post => "courses/1/comments" }.should be_routable
    {:delete => "courses/1/comments/1" }.should be_routable
    {:get => "courses/1/comments/1" }.should_not be_routable
    {:put => "courses/1/comments/1" }.should_not be_routable
    {:get => "courses/1/comments" }.should_not be_routable

    {:post => "comments" }.should_not be_routable
    {:delete => "comments/1" }.should_not be_routable
  end
end
