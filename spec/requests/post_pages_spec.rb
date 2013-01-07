require 'spec_helper'

describe "PostPages" do
  describe "GET /post_pages" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get posts_path
      response.status.should be(200)
    end
  end

  describe "The post/index page" do
    let(:user){create(:user)}
    let!(:post){create(:post, user: user)}
    before do
      visit posts_path
    end
    it {print page.html}
    it {page.should have_selector("p", text: "MyText")}
    it {page.should have_selector("h2", text: "MyString")}
    it {page.should have_content("Posted: ")}
    it {page.should have_content(post.author)}
  end

  describe "Showing a post" do
    let(:post){create(:post)}
    before {visit post_path(post)}
    it {page.should have_content(post.title)}
  end

  describe "Creating a new post" do
    context "When not signed in" do
      describe "it should not allow a user to create a post" do
        before {visit new_post_path}
        it {current_path.should eq(new_user_session_path)}
      end
    end

    context "When signed in" do
      before do
        sign_in_as_admin
        visit new_post_path
      end
      it {page.should have_content("New Post")}
      it "lets a user create a post" do
        expect{
          fill_in "post_title", with: "Title"
          fill_in "post_content", with: "Content"
          click_button "Add Post"
        }.to change(Post, :count).by(1)
      end
    end
  end

  describe "Editing a Post" do
    before do
      sign_in_as_admin
    end
    let!(:post){create(:post, user: @user)}
    it "allows me to visit edit path" do
      visit posts_path
      find_link("Edit Post").click
      current_path.should eq(edit_post_path(post))
    end
    it " it allows me to edit the post" do
      visit posts_path
      find_link("Edit Post").click
      fill_in "post_title", with: "New Title"
      click_button "Add Post"
      page.should have_content("New Title")
    end
  end

end
