class V1::ApiController < ApplicationController
  before_action :authenticate

  private

  attr_reader :current_user

  def authenticate
    token = request.authorization&.remove("Bearer ")

    @current_user = User.find_by(auth_token: token)
    unless token && current_user.present?
      render json: { error: "Unauthorized" }, status: :unauthorized
    end
  end
end
