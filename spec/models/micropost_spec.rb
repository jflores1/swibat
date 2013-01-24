# == Schema Information
#
# Table name: microposts
#
#  id         :integer          not null, primary key
#  content    :string(255)
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe Micropost do
  let(:user){build_stubbed(:user)}
  before {@micropost = user.microposts.build(content:"Lorem Ipsum")}

  subject {@micropost}
  it {should respond_to(:content)}
  it {should respond_to(:user)}

  describe "without content" do
    before {@micropost.content = ""}
    it {should_not be_valid}
  end

  describe "a post that's too long" do
    before {@micropost.content = "a"*150}
    it {should_not be_valid}
  end

  describe "sorted in descending order" do
    let!(:older_post){create(:micropost, user: user, created_at: 1.day.ago)}
    let!(:newer_post){create(:micropost, user: user, created_at: 1.hour.ago)}
    it {user.microposts.should == [newer_post, older_post]}
  end

end
