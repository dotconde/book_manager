class Borrowing < ApplicationRecord
  belongs_to :user
  belongs_to :book

  scope :active, -> { where(returned_at: nil) }
  scope :returned, -> { where.not(returned_at: nil) }
  scope :overdue, -> { active.where("due_date < ?", Date.current) }
  scope :due_today, -> { active.where(due_date: Date.current) }

  before_validation :set_borrow_defaults, on: :create

  validate :book_must_be_available, on: :create
  validate :no_duplicate_active_borrow, on: :create

  private

  def set_borrow_defaults
    self.borrowed_at ||= Time.current
    self.due_date ||= Date.current + 14.days
  end

  def book_must_be_available
    return unless book

    unless book.available?
      errors.add(:book, "is not available")
    end
  end

  def no_duplicate_active_borrow
    return unless user && book

    if Borrowing.active.exists?(user_id: user_id, book_id: book_id)
      errors.add(:book, "is already borrowed by you")
    end
  end
end
