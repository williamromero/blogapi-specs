class ApplicationController < ActionController::API
  include Secured
  # rescue_from Exception, with: :unauthorized
  # rescue_from ActiveRecord::RecordInvalid, with: :record_invalid
  # rescue_from ActiveRecord::RecordNotFound, with: :not_found  

  # def not_found
  #   render json: {error: exception.message}, status: :not_found
  # end

  # def record_invalid
  #   render json: {error: exception.message}, status: :unprocessable_entity
  # end

  # def unauthorized
  #   render json: {error: exception.message}, status: :unauthorized
  # end
end
