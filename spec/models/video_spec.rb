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
#

require 'spec_helper'

describe Video do
  pending "add some examples to (or delete) #{__FILE__}"
end
