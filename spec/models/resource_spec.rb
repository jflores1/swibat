# == Schema Information
#
# Table name: resources
#
#  id                  :integer          not null, primary key
#  name                :string(255)
#  description         :text
#  lesson_id           :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  upload_file_name    :string(255)
#  upload_content_type :string(255)
#  upload_file_size    :integer
#  upload_updated_at   :datetime
#

require 'spec_helper'

describe Resource do
	before do
		@resource = Resource.new(:name => "MyString", :description => "MyText", :upload => File.new(Rails.root + 'spec/fixtures/files/upload.txt'))
	end

	describe "Validations" do
		it "should have a name" do
			@resource.name = nil			
			puts @resource.to_json
			@resource.should_not be_valid
		end

		it "should have an attachment" do
			@resource.upload = nil
			@resource.should_not be_valid
			@resource.should have(1).errors_on(:upload)
		end
	end

end
