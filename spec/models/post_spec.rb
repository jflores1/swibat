# == Schema Information
#
# Table name: posts
#
#  id         :integer          not null, primary key
#  title      :string(255)
#  content    :text
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe Post do
  pending "add some examples to (or delete) #{__FILE__}"
  context "model construction and validation" do
  	let(:user){create(:user)}
  	let(:post){Post.new(title: "Post Title", content:"This is the post content", user: user)}

  	it {should respond_to(:content)}
  	it {should respond_to(:title)}
  	it {should respond_to(:tag_list)}

  	describe "A Post belongs to a user" do
  		let(:post){user.posts.create(:post)}
  		it {should respond_to(:user)}
  	end

  	describe "A Post has tags" do
  		let(:post){create(:post, tag_list: "tag, tag2")}
  		it "responds to tag list" do
  			post.tag_list.first.should eq("tag")
  			post.tag_list.last.should eq("tag2")
  		end
  	end

  	context "Validations" do
  		let(:post){build_stubbed(:post)}
  		describe "validation on title" do
  			before {post.title = ""}
  			it {should_not be_valid}
  			it {expect{post.save!}.to raise_error(ActiveRecord::RecordInvalid)}
  		end
  		describe "validation on post" do
  			before {post.content = ""}
  			it {should_not be_valid}
  			it {expect{post.save!}.to raise_error(ActiveRecord::RecordInvalid)}
  		end

  	end
  	
  end

end
