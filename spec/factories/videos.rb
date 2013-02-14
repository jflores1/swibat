# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :video do
    title "Video Title"
    description "A description of the video"
    yt_video_id "MyString"
  end
end
