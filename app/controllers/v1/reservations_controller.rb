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
        render json: { error: "Not allowed to see another person's reservation" }, status: :not_found
      end
    end

    def create
      reservation = ReservationCreator.new(reservation_params, current_user).call

      render json: reservation, status: :created
    rescue ActiveRecord::RecordInvalid => e
      render json: { error: e.record.errors }, status: :unprocessable_entity
    rescue ActiveRecord::LockWaitTimeout
      render json: { error: "Equipment is currently being reserved" }, status: :conflict
    rescue ActiveRecord::StatementInvalid => e
      raise unless e.cause.is_a?(PG::LockNotAvailable)

      render json: { error: "Equipment is currently being reserved" }, status: :conflict
    end

    def destroy
      if @reservation.user_id == @current_user.id
        if @reservation.starts_at < Time.zone.now
          render json: { error: "Not allowed to destroy a past reservation or ongoing" }, status: :unprocessable_entity
        else
          @reservation.destroy
        end
      else
        render json: { error: "Not allowed to destroy another person's reservation" }, status: :not_found
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
