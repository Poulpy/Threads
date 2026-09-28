# frozen_string_literal: true

class DateOverlapValidator < ActiveModel::Validator
  def validate(record)
    equipment_reservations = Reservation.where(equipment_id: record.equipment_id)

    equipment_reservations.each do |reservation|
      if (reservation.starts_at...reservation.ends_at).overlap?(record.starts_at...record.ends_at)
        record.errors.add :starts_at, 'should not overlap with other reservations'
      end
    end
  end
end
