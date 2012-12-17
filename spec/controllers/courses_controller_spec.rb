require 'spec_helper'

describe CoursesController do
  login_user
  render_views

  it "should have proper routes" do
    {:get => "courses/new" }.should be_routable
    {:get => "courses/1/edit" }.should be_routable
    {:get => "courses/1/" }.should be_routable
    {:post => "courses" }.should be_routable
    {:put => "courses/1" }.should be_routable
    {:delete => "courses/1" }.should be_routable
  end

  describe "Creating a new course" do

    let(:user){subject.current_user}

    it "should have a current_user" do
      user.should_not be_nil
    end

    it "should redirect to user path upon successful save" do
      user.courses.any_instance.stub(:valid?).and_return(true)
      post 'create'
      assigns[:course].should_not be_new_record
      flash[:notice].should_not be_nil
    end
  end


end
