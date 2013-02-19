# == Schema Information
#
# Table name: institutions
#
#  id             :integer          not null, primary key
#  name           :string(255)
#  enrollment     :string(255)
#  num_faculty    :string(255)
#  address_line_1 :string(255)
#  address_line_2 :string(255)
#  city           :string(255)
#  state          :string(255)
#  zip_code       :string(255)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

require 'spec_helper'

describe Institution do
	describe "the model and associations" do
		let(:institution) {Institution.new(name: "A School", enrollment: "200", num_faculty: "15", address_line_1: "Address 1", address_line_2: "Address 2", city: "Atlanta", state: "GA", zip_code: 30082)}

  	before {institution.save!}
  	subject {institution}
  	it {should respond_to(:name)}
  	it {should respond_to(:enrollment)}
  	it {should respond_to(:num_faculty)} 
  	it {should respond_to(:address_line_1)}
  	it {should respond_to(:address_line_2)}
  	it {should respond_to(:city)}
  	it {should respond_to(:state)}
  	it {should respond_to(:zip_code)}
  	it {should respond_to(:users)}
  	it {should respond_to(:evaluation_template)}
	end

	describe "Validations" do
	  let(:institution){build(:institution)}
	  describe "it requires a name" do
	    before {institution.name = " "}
	    it {should_not be_valid}
	    it {expect {institution.save!}.to raise_error(ActiveRecord::RecordInvalid)}
	  end
	end
   


end
