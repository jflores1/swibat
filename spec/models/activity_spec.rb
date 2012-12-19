# == Schema Information
#
# Table name: activities
#
#  id         :integer          not null, primary key
#  activity   :string(255)
#  duration   :string(255)
#  agent      :string(255)
#  lesson_id  :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe Activity do
  context "A new activity" do
    let(:activity){Activity.new(activity:"Lecture", duration:"15 minutes", agent:"Teacher")}
    describe "The Model" do
      subject {activity}
      it {should respond_to(:activity)}
      it {should respond_to(:duration)}
      it {should respond_to(:agent)}
    end

    describe "Validations" do

      describe "A valid model" do
        it "creates an activity" do
          build_stubbed(:activity)
          expect{activity.save!}.to change(Activity, :count).by(1)
        end
      end

      describe "without an activity" do
        before {activity.activity = ""}
        it {should_not be_valid}
        it {expect {activity.save!}.to raise_error(ActiveRecord::RecordInvalid)}
      end

      describe "with an invalid agent" do
        before {activity.agent = "Slob"}
        it {should_not be_valid}
        it {expect{activity.save!}.to raise_error(ActiveRecord::RecordInvalid)}
      end

    end

    describe "Associations" do
      let(:lesson){create(:lesson)}
      before{@activity = lesson.activities.build(activity:"A new activity", duration:"10 minutes", agent:"Student")}
      it {expect {lesson.save!}.to change(Activity, :count).by(1)}
    end
  end


end
