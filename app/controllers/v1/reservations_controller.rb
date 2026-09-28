class V1::ReservationsController < V1::ApiController
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

    if reservation.save
      render json: reservation, status: :created
    else
      render json: { error: reservation.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    @reservation.destroy
  end

  private
    def reservation_params
      params.expect(
        reservation: [
          :user_id,
          :equipment_id,
          :starts_at,
          :ends_at
        ]
      )
    end

    def set_reservation
      @reservation = Reservation.find(params[:id])
    end

    def set_page
      @page = if params[:page].present? && params[:page].to_i > 0
        params[:page].to_i
      else
        1
      end
    end
end
