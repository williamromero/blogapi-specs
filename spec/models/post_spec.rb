require 'rails_helper'

RSpec.describe Post, type: :model do
  
  describe "testing validations" do

    it "should validate presence of required fields" do
      should validate_presence_of(:title)
      should validate_presence_of(:content)
      should validate_presence_of(:user_id)      
    end

    it "validate relations" do
      should belong_to(:user)
    end

  end

end
