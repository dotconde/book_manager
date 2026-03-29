class Book < ApplicationRecord
  has_many :borrowings, dependent: :destroy
  has_many :borrowers, through: :borrowings, source: :user

  validates :title, presence: true, length: { in: 1..255 }
  validates :author, presence: true, length: { in: 1..255 }
  validates :genre, presence: true, length: { in: 1..100 }
  validates :isbn, presence: true, uniqueness: true
  validates :total_copies, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 1 }

  scope :search, ->(query) {
    return all if query.blank?
    where(
      "title ILIKE :q OR author ILIKE :q OR genre ILIKE :q",
      q: "%#{sanitize_sql_like(query)}%"
    )
  }

  def available_copies
    total_copies - borrowings.active.count
  end

  def available?
    available_copies > 0
  end
end
