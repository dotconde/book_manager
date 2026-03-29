require "rails_helper"

RSpec.describe Book, type: :model do
  describe "validations" do
    it "is valid with valid attributes" do
      expect(build(:book)).to be_valid
    end

    it "is invalid without a title" do
      expect(build(:book, title: nil)).not_to be_valid
    end

    it "is invalid without an author" do
      expect(build(:book, author: nil)).not_to be_valid
    end

    it "is invalid with a duplicate isbn" do
      create(:book, isbn: "978-0-123456-78-9")
      expect(build(:book, isbn: "978-0-123456-78-9")).not_to be_valid
    end
  end

  describe "#available_copies" do
    it "returns total_copies minus active borrowings" do
      book = create(:book, total_copies: 3)
      create(:borrowing, book: book)

      expect(book.available_copies).to eq(2)
    end
  end

  describe ".search" do
    let!(:fantasy_book) { create(:book, title: "The Hobbit", author: "Tolkien", genre: "Fantasy") }
    let!(:scifi_book) { create(:book, title: "Dune", author: "Herbert", genre: "Science Fiction") }

    it "searches by title" do
      expect(Book.search("Hobbit")).to include(fantasy_book)
      expect(Book.search("Hobbit")).not_to include(scifi_book)
    end

    it "returns all books when query is blank" do
      expect(Book.search("")).to include(fantasy_book, scifi_book)
    end
  end
end
