# == Schema Information
#
# Table name: videos
#
#  id          :integer          not null, primary key
#  title       :string(255)
#  description :text
#  yt_video_id :string(255)
#  is_complete :boolean          default(FALSE)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  lesson_id   :integer
#  user_id     :integer
#  uploader_id :integer
#

require 'spec_helper'
require "cancan/matchers"

describe Video do
  
  context "Tags" do

  end

  context "Abilities" do
  	before do 
  		@institution = Institution.create(name: "My institution")
  		@other_institution = Institution.create(name: "Another institution")  			
  		@user = FactoryGirl.create(:user, institution: @institution)
  		@other_user = FactoryGirl.create(:user)
  		course = FactoryGirl.create(:course, user: @other_user)
			unit = FactoryGirl.create(:unit, course: course)
			lesson = FactoryGirl.create(:lesson, unit: unit)
			@video = FactoryGirl.create(:video, user: @other_user, lesson: lesson, uploader: @other_user)
  		@ability = Ability.new(@user)	
  	end

  	describe "Users from the same institution" do
  		before { @other_user.institution = @institution }  			
      it "can access user's videos index" do
        @ability.should be_able_to(:videos, @other_user)
      end

  		it "can access videos" do
  			@ability.should be_able_to(:read, @video)
  		end

  		it "can upload videos" do
  			@ability.should be_able_to(:upload, Video)
  		end
  	end	

  	describe "Users from other institutions" do 
  		before {@other_user.institution = @other_institution}

      it "can not access user's videos index" do
        @ability.should_not be_able_to(:videos, @other_user)
      end

  		it "can not access videos" do
				@ability.should_not be_able_to(:read, @video)
  		end

      it "can not upload videos" do
        @ability.should_not be_able_to(:upload, Video)
      end

  	end
  end
end
