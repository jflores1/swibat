# == Schema Information
#
# Table name: links
#
#  id         :integer          not null, primary key
#  link_type  :string(255)
#  url        :string(255)
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe Link do
  pending "add some examples to (or delete) #{__FILE__}"
end
