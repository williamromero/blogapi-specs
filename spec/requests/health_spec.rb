require 'rails_helper'

RSpec.describe 'Health endpoint', type: :request do
  describe 'GET /health' do

    before { get '/health' }

    it "should return OK" do
      payload = JSON.parse(response.body)
      expect(payload).not_to be_empty
      expect(payload['api']).to eq("OK")
      expect(response.status).to eq(200)
    end

    it 'should not return YES' do
      expect(response.body).not_to eq("YES")
    end

  end

end
