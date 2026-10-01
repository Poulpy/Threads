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
        starts_at: Time.zone.local(2316, 10, 5, 9, 0),
        ends_at: Time.zone.local(2316, 10, 5, 12, 0)
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
      expect(response).to have_http_status(:not_found)
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

    context 'when the equipment is already locked' do
      self.use_transactional_tests = false

      let(:user)      { users(:paul) }
      let(:params)    { valid_params[:reservation] }
      let(:equipment) { Equipment.find(params[:equipment_id]) }

      def create_reservation_from_another_connection
        thread = Thread.new do
          Thread.current.report_on_exception = false
          ActiveRecord::Base.connection_pool.with_connection do
            ReservationCreator.new(params, user).call
          end
        end
        thread.join
      end

      it 'raises a lock error' do
        equipment.with_lock do
          expect { create_reservation_from_another_connection }
            .to raise_error ActiveRecord::LockWaitTimeout
        end
      end

      def attempt_while_locked
        equipment.with_lock do
          create_reservation_from_another_connection
        rescue ActiveRecord::LockWaitTimeout
          nil
        end
      end

      it 'does not create a reservation' do
        expect { attempt_while_locked }
          .not_to(change { Reservation.where(equipment_id: equipment.id).count })
      end
    end
  end

  describe 'DELETE /destroy' do
    it 'deletes a reservation' do
      delete "/v1/reservations/#{reservations(:paul_sewing).id}", headers: auth_header
      expect(response).to have_http_status(:no_content)
    end
  end
end
