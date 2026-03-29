class BorrowingSerializer
  include JSONAPI::Serializer

  attributes :borrowed_at, :due_date, :returned_at

  attribute :overdue do |borrowing|
    borrowing.returned_at.nil? && borrowing.due_date < Date.current
  end

  belongs_to :user
  belongs_to :book
end
