require 'rails_helper'

RSpec.describe Answer, type: :model do
  
  describe "validaion tests" do
    it {should validate_presence_of :body}
    it {should validate_presence_of :question_id}
  end

  describe "association tests" do
  	it {should belong_to(:question)}
  end
end