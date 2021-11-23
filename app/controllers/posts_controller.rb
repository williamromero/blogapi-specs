class PostsController < ApplicationController
  before_action :authenticate_user, only: [:create, :show, :update]

  rescue_from Exception do |e|
    render json: {error: e.message}, status: :unauthorized
  end

  rescue_from ActiveRecord::RecordInvalid do |e|
    render json: {error: e.message}, status: :unprocessable_entity
  end

  rescue_from ActiveRecord::RecordNotFound do |e|
    render json: {error: e.message}, status: :not_found
  end  

  # GET /posts
  def index
    @posts = Post.where(published: true)
    if !params[:search].nil? && params[:search].present?
      @posts = SearchPostsService.search(@posts, params[:search])
    end
    render json: @posts.includes(:user), status: :ok
  end

  # GET /posts/{id}
  def show
    @post = Post.find(params[:id])
    # pp Current.user
    if @post.published? || (Current.user && @post.user_id == Current.user.id)
      render json: @post, status: :ok
    else
      render json: {error: 'Not Found'}, status: :not_found
    end
  end

  # POST /posts
  def create
    @post = Current.user.posts.create!(post_params)
    render json: @post, status: :created
  end

  # PUT /posts/{id}
  def update
    @post = Current.user.posts.find(params[:id])
    @post.update!(post_params)
    render json: @post, status: :ok
  end

  private

  def post_params
    params.require(:post).permit(:title, :content, :published)
  end

end
