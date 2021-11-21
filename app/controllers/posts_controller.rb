class PostsController < ApplicationController

  rescue_from Exception do |e|
    render json: {error: e.message}, status: :internal_error
  end

  rescue_from ActiveRecord::RecordInvalid do |e|
    render json: {error: e.message}, status: :unprocessable_entity
  end

  def index
    @posts = Post.where(published: true)
    @posts = SearchPostsService.search(@posts, params[:search]) if !params[:search].nil? && params[:search].present?
    render json: @posts, status: :ok
  end

  def show
    @post = Post.find_by(params[:id])
    render json: @post, status: :ok
  end

  def create
    @post = Post.create!(post_params)
    render json: @post, status: :created
  end

  def update
    @post = Post.find_by(params[:id])
    @post.update!(post_params)
    render json: @post, status: :ok
  end


  private

  def post_params
    params.require(:post).permit(:title, :content, :published, :user_id)
  end
end
