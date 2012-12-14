# == Schema Information
#
# Table name: questions
#
#  id         :integer          not null, primary key
#  title      :string(255)
#  text       :text
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe Question do
	let(:question){FactoryGirl.build(:question)}
  subject {question}

  describe "Attributes and relations" do
    it {should respond_to(:title)}
    it {should respond_to(:text)}
    it {should respond_to(:user)}    
    it {should respond_to(:answers)}    
    it {should respond_to(:reputation_for)}
  end

  describe "Validations" do  	  	
  	describe "without a title" do
      before {question.title = ""}
      it {should_not be_valid}
      it {expect {question.save!}.to raise_error(ActiveRecord::RecordInvalid)}
    end

    describe "without a text" do
      before {question.text = ""}
      it {should_not be_valid}
      it {expect {question.save!}.to raise_error(ActiveRecord::RecordInvalid)}
    end

    describe "With text longer than the limit" do
      before {question.text = "-" * 4001}
      it {should_not be_valid}
      it {expect {question.save!}.to raise_error(ActiveRecord::RecordInvalid)}
    end
  end

  context "Associations" do
    let(:question){FactoryGirl.create(:question)}

    describe "can have at least one answer" do
      before {answer = question.answers.build(text:"my answer", user:FactoryGirl.build(:user))}
      it {expect {question.save!}.to change{Answer.count}.by(1)}
    end

    describe "Can have multiple answers" do
      before {answer = question.answers.create(text:"my answer", user:FactoryGirl.build(:user))}
      before {answer = question.answers.create(text:"my second", user:FactoryGirl.build(:user))}
      it {question.answers.count.should == 2}
    end

  end


end

