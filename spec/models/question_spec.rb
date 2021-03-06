require 'rails_helper'

RSpec.describe Question, type: :model do
  
  describe "validation tests" do
    it {should validate_presence_of :title}
    it {should validate_presence_of :body}
    it {should validate_presence_of :user_id}
  end

  describe "association tests" do
    it {should belong_to(:user)}
    it { should have_many(:answers).dependent(:destroy) }
    it { should have_many(:attachments).dependent(:destroy) }
    it { should have_many(:votes).dependent(:destroy) } 
    it { should have_many(:comments).dependent(:destroy) } 
  end

  it { should accept_nested_attributes_for :attachments }

  describe 'create subscription for question author' do
    let!(:question) { build(:question) }

    it 'save new subscription in database' do
      expect{ question.save }.to change(Subscription, :count).by(1)
    end
  end  
end
