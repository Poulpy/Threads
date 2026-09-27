# frozen_string_literal: true

module V1
  class ApiController < ApplicationController
    before_action :authenticate

    private

    attr_reader :current_user

    def authenticate
      token = request.authorization&.remove('Bearer ')

      @current_user = User.find_by(auth_token: token)
      return if token && current_user.present?

      render json: { error: 'Unauthorized' }, status: :unauthorized
    end
  end
end
