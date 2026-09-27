# frozen_string_literal: true

class Equipment < ApplicationRecord
  class InvalidCategoryError < StandardError; end
  class InvalidPageError < StandardError; end

  has_many :reservations, dependent: :destroy

  enum :category, {
    sewing: 0,
    knitting: 1,
    crochet: 2,
    tatting: 3,
    lace: 4,
    embroidery: 5,
    cross_stitch: 6,
    weaving: 7,
    macrame: 8,
    spinning: 9,
    felting: 10
  }

  validates :category, presence: true
  validates :name, presence: true

  scope :search_by_name, ->(term) { where('name ILIKE ?', "%#{sanitize_sql_like(term)}%") }
end
