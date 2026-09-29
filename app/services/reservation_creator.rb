class ReservationCreator
  def initialize(reservation_params, user)
    @reservation_params = reservation_params
    @user = user
  end

  def call
    equipment = Equipment.find(@reservation_params[:equipment_id])

    equipment.with_lock("FOR UPDATE NOWAIT") do
      reservation = @user.reservations.build(@reservation_params)
      reservation.save!
      reservation
    end
  end
end
