require "rails_helper"

RSpec.describe "Borrowings API", type: :request do
  let(:librarian) { create(:user, :librarian) }
  let(:member) { create(:user, :member) }

  describe "POST /api/v1/borrowings" do
    let(:book) { create(:book, total_copies: 2) }

    it "member can borrow an available book" do
      expect {
        post "/api/v1/borrowings",
             params: { borrowing: { book_id: book.id } },
             headers: auth_headers(member)
      }.to change(Borrowing, :count).by(1)
      expect(response).to have_http_status(:created)
    end

    it "returns 422 when book is not available" do
      book.update!(total_copies: 1)
      create(:borrowing, book: book)

      post "/api/v1/borrowings",
           params: { borrowing: { book_id: book.id } },
           headers: auth_headers(member)
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it "returns 422 when already borrowed by same user" do
      create(:borrowing, user: member, book: book)
      post "/api/v1/borrowings",
           params: { borrowing: { book_id: book.id } },
           headers: auth_headers(member)
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it "librarian cannot borrow" do
      post "/api/v1/borrowings",
           params: { borrowing: { book_id: book.id } },
           headers: auth_headers(librarian)
      expect(response).to have_http_status(:forbidden)
    end
  end

  describe "PATCH /api/v1/borrowings/:id/return" do
    let(:borrowing) { create(:borrowing) }

    it "librarian can mark as returned" do
      patch return_api_v1_borrowing_path(borrowing), headers: auth_headers(librarian)
      expect(response).to have_http_status(:ok)
      expect(borrowing.reload.returned_at).to be_present
    end

    it "member cannot mark as returned" do
      patch return_api_v1_borrowing_path(borrowing), headers: auth_headers(member)
      expect(response).to have_http_status(:forbidden)
    end
  end
end
