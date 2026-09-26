require "test_helper"

class ReservationTest < ActiveSupport::TestCase
  test "start should not be before end on create" do
    res = Reservation.new(
          user: users(:paul),
          equipment: equipments(:sewing_machine),
          starts_at: DateTime.civil_from_format(:local, 2012, 12, 17),
          ends_at: DateTime.civil_from_format(:local, 2012, 12, 16)
        )

    assert_not(res.save)
  end

  test "reservations should not overlap each other with the same equipment" do
    res1 = Reservation.new(
      user: users(:paul),
      equipment: equipments(:sewing_machine),
      starts_at: DateTime.civil_from_format(:local, 2012, 12, 16),
      ends_at: DateTime.civil_from_format(:local, 2012, 12, 20)
    )

    res2 = Reservation.new(
      user: users(:paul),
      equipment: equipments(:sewing_machine),
      starts_at: DateTime.civil_from_format(:local, 2012, 12, 19),
      ends_at: DateTime.civil_from_format(:local, 2012, 12, 22)
    )
    assert(res1.save)
    assert_not(res2.save)
  end

  test "reservations can overlap each other with different equipment" do
    res1 = Reservation.new(
      user: users(:paul),
      equipment: equipments(:sewing_machine),
      starts_at: DateTime.civil_from_format(:local, 2012, 12, 16),
      ends_at: DateTime.civil_from_format(:local, 2012, 12, 20)
    )

    res2 = Reservation.new(
      user: users(:paul),
      equipment: equipments(:knitting_machine),
      starts_at: DateTime.civil_from_format(:local, 2012, 12, 19),
      ends_at: DateTime.civil_from_format(:local, 2012, 12, 22)
    )
    assert(res1.save)
    assert(res2.save)
  end


  test "reservation should have an equipment" do
    res1 = Reservation.new(
      user: users(:paul),
      equipment: nil,
      starts_at: DateTime.civil_from_format(:local, 2012, 12, 19),
      ends_at: DateTime.civil_from_format(:local, 2012, 12, 22)
    )
    assert_not(res1.save)
  end

  test "reservation should have a user" do
    res1 = Reservation.new(
      user: nil,
      equipment: equipments(:sewing_machine),
      starts_at: DateTime.civil_from_format(:local, 2012, 12, 19),
      ends_at: DateTime.civil_from_format(:local, 2012, 12, 22)
    )
    assert_not(res1.save)
  end

  test "reservation should have a start date" do
    res1 = Reservation.new(
      user: users(:paul),
      equipment: equipments(:sewing_machine),
      starts_at: nil,
      ends_at: DateTime.civil_from_format(:local, 2012, 12, 22)
    )
    assert_not(res1.save)
  end

  test "reservation should have an end date" do
    res1 = Reservation.new(
      user: users(:paul),
      equipment: equipments(:sewing_machine),
      starts_at: DateTime.civil_from_format(:local, 2012, 12, 19),
      ends_at: nil
    )
    assert_not(res1.save)
  end
end
