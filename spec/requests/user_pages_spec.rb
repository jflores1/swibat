require 'spec_helper'

describe "UserPages" do
  subject { page }

  context "When signed in" do
    before do
      sign_in_via_form
    end

    describe "Accesses Profile Page" do
      before {visit user_path(@user)}
      it {page.should have_content(@user.full_name)}
      it {page.should have_selector("img[alt='Jesse Flores']")}
      it {page.should have_content("Create a Course")}
    end

    describe "Can see All Users" do
      before {visit users_path}
      it {page.should have_content "All Users"}
    end

  end

  context "When not signed in" do
    let(:user){FactoryGirl.create(:user)}

    describe "Can access users path" do
      before {visit users_path}
      it {page.should have_content("All Users")}
    end

  end

  context "With relevant profile information displayed" do

    xit "only shows attributes that the user has filled out" do

    end

    xit "it does not show attributes teh user has not filled out" do

    end
  end

  context "With navigation tools available" do

    xit "A user can access their course info in one place" do

    end

    xit "A user can navigate from course through lesson" do

    end

    xit "A user can see active lessons" do

    end
  end

  context "With a working feed" do

    describe "Relevant suggestions" do

      xit "Suggested lessons relate to courses the user is teaching" do

      end

      xit "A user can click a link and see a lesson in context" do

      end

    end


    xit "A user can see comments provided by friends" do

    end

  end


end
