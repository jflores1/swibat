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
