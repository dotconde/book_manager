require "rails_helper"

RSpec.describe Borrowing, type: :model do
  describe "validations" do
    it "is valid with valid attributes" do
      expect(build(:borrowing)).to be_valid
    end

    it "sets borrowed_at and due_date automatically" do
      borrowing = build(:borrowing, borrowed_at: nil, due_date: nil)
      borrowing.valid?
      expect(borrowing.borrowed_at).to be_present
      expect(borrowing.due_date).to eq(Date.current + 14.days)
    end

    it "prevents borrowing when no copies available" do
      book = create(:book, total_copies: 1)
      create(:borrowing, book: book)

      expect(build(:borrowing, book: book)).not_to be_valid
    end

    it "prevents duplicate active borrowing of same book by same user" do
      user = create(:user, :member)
      book = create(:book)
      create(:borrowing, user: user, book: book)

      expect(build(:borrowing, user: user, book: book)).not_to be_valid
    end

    it "allows re-borrowing after return" do
      user = create(:user, :member)
      book = create(:book)
      create(:borrowing, :returned, user: user, book: book)

      expect(build(:borrowing, user: user, book: book)).to be_valid
    end
  end

  describe "scopes" do
    let!(:active_borrowing) { create(:borrowing) }
    let!(:returned_borrowing) { create(:borrowing, :returned) }
    let!(:overdue_borrowing) { create(:borrowing, :overdue) }

    it ".active returns only unreturned borrowings" do
      expect(Borrowing.active).to include(active_borrowing, overdue_borrowing)
      expect(Borrowing.active).not_to include(returned_borrowing)
    end

    it ".overdue returns active borrowings past due date" do
      expect(Borrowing.overdue).to include(overdue_borrowing)
      expect(Borrowing.overdue).not_to include(active_borrowing)
    end
  end
end
