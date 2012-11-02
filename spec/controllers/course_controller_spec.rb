require 'spec_helper'

describe CourseController do
  login_user
  render_views

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
      response.should redirect_to(user_path(user))
    end
  end


end
