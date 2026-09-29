# frozen_string_literal: true

class DateOverlapValidator < ActiveModel::Validator
  def validate(record)
    return if record.starts_at.blank? || record.ends_at.blank?

    overlapping = Reservation
                  .where(equipment_id: record.equipment_id)
                  .where.not(id: record.id)
                  .where('starts_at < ? AND ends_at > ?', record.ends_at, record.starts_at)

    return unless overlapping.exists?

    record.errors.add(:starts_at, :overlap)
  end
end
