class V1::AuthController < ApplicationController

  def login
    naame = params[:name]
    email = params[:email]
    user = User.find_by(name: naame, email: email)
    if user.present?
      user.update auth_token: SecureRandom.uuid_v7()

      render json: { token: user.auth_token }
    else
      render json: { error: "Authentication failed" }, status: :unprocessable_entity
    end
  end
end
