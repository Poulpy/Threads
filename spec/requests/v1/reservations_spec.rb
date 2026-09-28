# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'v1/reservations', type: :request do
  fixtures :users
  fixtures :equipments
  fixtures :reservations

  let(:valid_params) do
    {
      reservation: {
        user_id: users(:paul).id,
        equipment_id: equipments(:sewing_machine).id,
        starts_at: Time.zone.local(2016, 10, 5, 9, 0),
        ends_at: Time.zone.local(2016, 10, 5, 12, 0)
      }
    }
  end

  let(:auth_header) do
    { 'Authorization' => "Bearer #{users(:paul).auth_token}" }
  end

  describe 'GET /index' do
    it "gets all user's reservations (pagined)" do
      get '/v1/reservations', headers: auth_header
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET /show' do
    it 'gets a user reservation' do
      get "/v1/reservations/#{reservations(:paul_sewing).id}", headers: auth_header
      expect(response).to have_http_status(:success)
    end

    it "does not allow to see another's reservation" do
      get "/v1/reservations/#{reservations(:alice_sewing).id}", headers: auth_header
      expect(response).to have_http_status(:unauthorized)
    end

    it 'does return not found on fictive id' do
      get '/v1/reservations/345123', headers: auth_header
      expect(response).to have_http_status(:not_found)
    end
  end

  describe 'POST /create' do
    it 'creates a reservation' do
      post '/v1/reservations', params: valid_params, headers: auth_header
      expect(response).to have_http_status(:created)
    end
  end

  describe 'DELETE /destroy' do
    it 'deletes a reservation' do
      delete "/v1/reservations/#{reservations(:paul_sewing).id}", headers: auth_header
      expect(response).to have_http_status(:no_content)
    end
  end
end
