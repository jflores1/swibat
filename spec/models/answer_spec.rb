# == Schema Information
#
# Table name: answers
#
#  id          :integer          not null, primary key
#  text        :text
#  question_id :integer
#  user_id     :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'spec_helper'

describe Answer do
	let(:answer){FactoryGirl.build(:answer)}
  subject {answer}

  describe "Attributes and relations" do
    it {should respond_to(:text)}
    it {should respond_to(:user)}    
    it {should respond_to(:question)}    
  end

  describe "Validations" do  	  	
  	describe "without a text" do
      before {answer.text = ""}
      it {should_not be_valid}
      it {expect {answer.save!}.to raise_error(ActiveRecord::RecordInvalid)}
    end

    describe "With text longer than the limit" do
      before {answer.text = "-" * 4001}
      it {should_not be_valid}
      it {expect {answer.save!}.to raise_error(ActiveRecord::RecordInvalid)}
    end

  end
end
