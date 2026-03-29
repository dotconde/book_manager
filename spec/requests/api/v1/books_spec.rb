require "rails_helper"

RSpec.describe "Books API", type: :request do
  let(:librarian) { create(:user, :librarian) }
  let(:member) { create(:user, :member) }

  describe "GET /api/v1/books" do
    let!(:books) { create_list(:book, 3) }

    it "returns all books" do
      get "/api/v1/books", headers: auth_headers(member)
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json["data"].size).to eq(3)
    end

    it "searches books by title" do
      create(:book, title: "Unique Title XYZ")
      get "/api/v1/books", params: { search: "Unique Title" }, headers: auth_headers(member)
      json = JSON.parse(response.body)
      expect(json["data"].size).to eq(1)
    end

    it "returns 401 without authentication" do
      get "/api/v1/books"
      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe "POST /api/v1/books" do
    let(:book_params) do
      { book: { title: "New Book", author: "Author", genre: "Fiction", isbn: "978-1234567890", total_copies: 3 } }
    end

    it "librarian can create a book" do
      expect {
        post "/api/v1/books", params: book_params, headers: auth_headers(librarian)
      }.to change(Book, :count).by(1)
      expect(response).to have_http_status(:created)
    end

    it "member cannot create a book" do
      post "/api/v1/books", params: book_params, headers: auth_headers(member)
      expect(response).to have_http_status(:forbidden)
    end
  end

  describe "DELETE /api/v1/books/:id" do
    let!(:book) { create(:book) }

    it "librarian can delete a book" do
      expect {
        delete "/api/v1/books/#{book.id}", headers: auth_headers(librarian)
      }.to change(Book, :count).by(-1)
      expect(response).to have_http_status(:no_content)
    end

    it "member cannot delete a book" do
      delete "/api/v1/books/#{book.id}", headers: auth_headers(member)
      expect(response).to have_http_status(:forbidden)
    end
  end
end
