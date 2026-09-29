# frozen_string_literal: true

module V1
  class ReservationsController < V1::ApiController
    PAGE_SIZE = 5

    before_action :set_reservation, only: %i[show destroy]

    def index
      set_page

      reservations = @current_user.reservations
                                  .limit(PAGE_SIZE)
                                  .offset((@page - 1) * PAGE_SIZE)

      render json: reservations
    end

    def show
      if @reservation.user_id.eql?(@current_user.id)
        render json: @reservation
      else
        render json: { error: "Not allowed to see another person's reservation" }, status: :unauthorized
      end
    end

    def create
      reservation = Reservation.new(reservation_params)
      reservation.user_id = @current_user.id
      ActiveRecord::Base.transaction do
        if reservation.save
          render json: reservation, status: :created
        else
          render json: { error: reservation.errors }, status: :unprocessable_entity
        end
      rescue StandardError
        render json: { error: 'Someone is trying to use the same equipment as you, aborting. Please retry.' },
               status: :conflict
      end
    end

    def destroy
      if @reservation.user_id == @current_user.id
        @reservation.destroy
      else
        render json: { error: "Not allowed to destroy another person's reservation" }, status: :unauthorized
      end
    end

    private

    def reservation_params
      params.expect(
        reservation: %i[
          equipment_id
          starts_at
          ends_at
        ]
      )
    end

    def set_reservation
      @reservation = Reservation.find(params[:id])
    end

    def set_page
      @page = if params[:page].present? && params[:page].to_i.positive?
                params[:page].to_i
              else
                1
              end
    end
  end
end
