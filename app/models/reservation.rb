# frozen_string_literal: true

class Reservation < ApplicationRecord
  belongs_to :equipment
  belongs_to :user

  validates :ends_at, comparison: { greater_than: :starts_at }

  validates_with DateOverlapValidator
end
