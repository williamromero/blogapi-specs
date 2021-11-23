require 'rails_helper'

RSpec.describe 'Posts with Authentication Tests', type: :request do
  let!(:user)         { create(:user) }
  let!(:other_user)   { create(:user) }
  let!(:user_post)    { create(:post, user_id: user.id, published: true) }
  let!(:other_post)   { create(:post, user_id: other_user.id, published: false) }

  let!(:auth_headers) { { "Authorization": "Bearer #{user.auth_token}" } }
  let!(:other_auth_headers) { { "Authorization": "Bearer #{other_user.auth_token}" } }

  let!(:create_params)  { { post: { title: 'title', content: 'content', published: true } } }
  let!(:updated_params)  { { post: { title: 'title', content: 'content', published: true } } }

  describe 'GET /posts/{id}' do
    context "with valid auth" do
      context "when requisting other's author post" do
        
        context "when post is public" do
          before { get "/posts/#{user_post.id}", headers: auth_headers }
          
          context "payload" do
            subject { payload }
            it { is_expected.to include(:id) }
          end

          context "response" do
            subject { response }
            it { is_expected.to have_http_status(:ok) }
          end
        end

        # context "when post is draft" do
        #   before { get "/posts/#{other_post.id}", headers: other_auth_headers }
          
        #   context "payload" do
        #     subject { payload }
        #     it { is_expected.to include(:error) }
        #   end

        #   context "response" do
        #     subject { response }
        #     it { is_expected.to have_http_status(:not_found) }
        #   end
        # end
        
      end

      context "when requisting user's post" do
      end
    end
    
  end

  describe "POST /posts" do
    # WITH AUTH > CREATE
    context "With valid auth" do
      before { post "/posts", headers: other_auth_headers, params: create_params }
      
      context "payload" do
        subject { payload }
        it { is_expected.to include(:id, :title, :content, :published, :author) }
      end

      context "response" do
        subject { response }
        it { is_expected.to have_http_status(:created) }
      end
    end
    # WITHOUT AUTH > !CREATE > 401
    context "Without valid auth" do
      before { post "/posts", params: create_params }
      
      context "payload" do
        subject { payload }
        it { is_expected.to include(:error) }
      end

      context "response" do
        subject { response }
        it { is_expected.to have_http_status(:unauthorized) }
      end
    end    
  end

  describe "PUT /posts" do
    # WITH AUTH > CREATE
    context "With valid auth" do
      context "when updating users's post" do
        
        before { put "/posts/#{user_post.id}", headers: auth_headers, params: updated_params }
        context "payload" do
          subject { payload }
          it { is_expected.to include(:id, :title, :content, :published, :author) }
          it { expect(payload[:id]).to eq(user_post.id) }
        end

        context "response" do
          subject { response }
          it { is_expected.to have_http_status(:ok) }
        end
      end

      context "when updating user's other post" do
        
        before { put "/posts/#{other_post.id}", headers: auth_headers, params: updated_params }
        context "payload" do
          subject { payload }
          it { is_expected.to include(:error) }
        end

        context "response" do
          subject { response }
          it { is_expected.to have_http_status(:not_found) }
        end
      end
      
      # WITHOUT AUTH > !CREATE > 401
      context "when updating other users post" do
        before { put "/posts/#{other_post.id}", params: updated_params }
        context "payload" do
          subject { payload }
          it { is_expected.to include(:error) }
        end

        context "response" do
          subject { response }
          it { is_expected.to have_http_status(:unauthorized) }
        end        
      end
    end    
  end

  private

  def payload
    JSON.parse(response.body).with_indifferent_access
  end
end
