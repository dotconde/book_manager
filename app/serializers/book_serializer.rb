class BookSerializer
  include JSONAPI::Serializer

  attributes :title, :author, :genre, :isbn, :total_copies

  attribute :available_copies do |book|
    book.available_copies
  end
end
