require 'rails_helper'

RSpec.describe 'Posts Endpoint', type: :request do
  
  describe 'GET /posts' do
    let!(:posts) { create_list(:post, 10, published: true) }
    
    before { get '/posts' }
    
    it "should return OK" do
      payload = JSON.parse(response.body)
      expect(payload).to_not be_empty
      expect(response.status).to eq(200)
    end
    
    it 'should not return YES' do
      expect(response.body).to_not eq("YES")
    end
    
    describe 'test routes with real DB data' do
      before { get '/posts' }
      
      it 'should display all published posts' do
        payload = JSON.parse(response.body)
        expect(payload.size).to eq(posts.size)
        expect(payload[0]["title"]).to eq(posts[0].title)
        expect(payload[0]["content"]).to eq(posts[0].content)
        expect(payload[0]["author"]["id"]).to_not eq(0)
        expect(payload[0]["author"]["id"]).to_not be_nil
        expect(payload[0]["author"]["name"]).to_not be_empty
        expect(payload[0]["author"]["email"]).to_not be_empty        
        expect(response.status).to eq(200)
      end
    end

    describe 'search request' do
      let!(:title_one)    { create(:published_post, title: 'Hola mundo') }
      let!(:title_two)    { create(:published_post, title: 'Hola title') }
      let!(:title_three)  { create(:published_post, title: 'Texto de prueba') }

      before { get '/posts?search=Hola' }
      
      it 'should filter all results searched' do
        payload = JSON.parse(response.body)
        expect(payload).to_not be_nil
        expect(payload.size).to eq(2)
        expect(payload.map {|p| p["id"] }.sort).to eq([title_one.id, title_two.id])
      end
    end

  end

  # describe 'GET /posts/{id}' do
  #   let!(:post) { create(:post, published: true) }
    
  #   before { get "/posts/#{post.id}" }
    
  #   it 'should return a post' do
  #     payload = JSON.parse(response.body)
  #     expect(payload).to_not be_empty
  #     expect(payload["id"]).to eq(post.id)
  #     expect(payload["title"]).to eq(post.title)
  #     expect(payload["content"]).to eq(post.content)            
  #     expect(payload["author"]["id"]).to_not eq(0)
  #     expect(payload["author"]["id"]).to_not be_nil
  #     expect(payload["author"]["name"]).to_not be_empty
  #     expect(payload["author"]["email"]).to_not be_empty
  #     expect(response.status).to eq(200)
  #   end
  # end

  # describe 'POST /posts' do
  #   let!(:user) { create(:user) }

  #   it "should create a post" do
  #     headers = { "ACCEPT" => "application/json" }
  #     req_payload = {
  #       post: {
  #         title: "Titulo",
  #         content: "Labore officia enim esse magna. Laboris adipisicing et eiusmod elit mollit.",
  #         published: true,
  #         user_id: user.id
  #       }
  #     }
  #     # POST HTTP 
  #     post "/posts", params: req_payload, headers: headers

  #     payload = JSON.parse(response.body)
  #     expect(payload).to_not be_empty
  #     expect(payload["id"]).to_not be_nil
  #   end
  # end

  # describe 'PATCH /posts' do
  #   let!(:article) { create(:post) }

  #   it "shouled update a post" do
  #     req_payload = {
  #       post: {
  #         title: "titulo",
  #         content: "content",
  #         published: true
  #       }
  #     }
  #     # PUT HTTP
  #     put "/posts/#{article.id}", params: req_payload
  #     payload = JSON.parse(response.body)
  #     expect(payload).to_not be_empty
  #     expect(payload["id"]).to eq(article.id)
  #     expect(response).to have_http_status(:ok)
  #   end

  #   it "should return error message on invalid post" do
  #     req_payload = {
  #       post: {
  #         title: nil,
  #         content: nil,
  #         published: false,
  #       }
  #     }
  #     # PUT HTTP
  #     put "/posts/#{article.id}", params: req_payload
  #     payload = JSON.parse(response.body)
  #     expect(payload).to_not be_empty
  #     expect(payload["error"]).to_not be_empty
  #     expect(response).to have_http_status(:unprocessable_entity)
  #   end    
  # end

end
