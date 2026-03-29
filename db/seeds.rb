puts "Before running seeds, let's clear the database ..."
Borrowing.destroy_all
Book.destroy_all
User.destroy_all

puts "Creating librarians..."
librarian1 = User.create!(
  email: "librarian@library.com",
  password: "password123",
  first_name: "Sarah",
  last_name: "Johnson",
  role: :librarian
)

librarian2 = User.create!(
  email: "admin@library.com",
  password: "password123",
  first_name: "Michael",
  last_name: "Chen",
  role: :librarian
)

puts "Creating members..."
members = (1..5).map do |i|
  User.create!(
    email: "member#{i}@example.com",
    password: "password123",
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    role: :member
  )
end

puts "Creating books..."
books_data = [
  { title: "The Great Gatsby", author: "F. Scott Fitzgerald", genre: "Fiction", isbn: "978-0743273565", total_copies: 3 },
  { title: "To Kill a Mockingbird", author: "Harper Lee", genre: "Fiction", isbn: "978-0061120084", total_copies: 2 },
  { title: "1984", author: "George Orwell", genre: "Dystopian", isbn: "978-0451524935", total_copies: 4 },
  { title: "The Hobbit", author: "J.R.R. Tolkien", genre: "Fantasy", isbn: "978-0547928227", total_copies: 3 },
  { title: "Dune", author: "Frank Herbert", genre: "Science Fiction", isbn: "978-0441013593", total_copies: 2 },
  { title: "Pride and Prejudice", author: "Jane Austen", genre: "Romance", isbn: "978-0141439518", total_copies: 3 },
  { title: "The Catcher in the Rye", author: "J.D. Salinger", genre: "Fiction", isbn: "978-0316769488", total_copies: 2 },
  { title: "Brave New World", author: "Aldous Huxley", genre: "Dystopian", isbn: "978-0060850524", total_copies: 3 },
  { title: "The Lord of the Rings", author: "J.R.R. Tolkien", genre: "Fantasy", isbn: "978-0618640157", total_copies: 2 },
  { title: "Fahrenheit 451", author: "Ray Bradbury", genre: "Science Fiction", isbn: "978-1451673319", total_copies: 3 },
  { title: "Jane Eyre", author: "Charlotte Brontë", genre: "Romance", isbn: "978-0141441146", total_copies: 2 },
  { title: "The Alchemist", author: "Paulo Coelho", genre: "Fiction", isbn: "978-0062315007", total_copies: 4 },
  { title: "Sapiens", author: "Yuval Noah Harari", genre: "Non-Fiction", isbn: "978-0062316097", total_copies: 3 },
  { title: "Educated", author: "Tara Westover", genre: "Biography", isbn: "978-0399590504", total_copies: 2 },
  { title: "The Art of War", author: "Sun Tzu", genre: "History", isbn: "978-1599869773", total_copies: 3 },
  { title: "Atomic Habits", author: "James Clear", genre: "Non-Fiction", isbn: "978-0735211292", total_copies: 5 },
  { title: "The Shining", author: "Stephen King", genre: "Horror", isbn: "978-0307743657", total_copies: 2 },
  { title: "Murder on the Orient Express", author: "Agatha Christie", genre: "Mystery", isbn: "978-0062693662", total_copies: 3 },
  { title: "Foundation", author: "Isaac Asimov", genre: "Science Fiction", isbn: "978-0553293357", total_copies: 2 },
  { title: "The Name of the Wind", author: "Patrick Rothfuss", genre: "Fantasy", isbn: "978-0756404741", total_copies: 3 },
  { title: "A Brief History of Time", author: "Stephen Hawking", genre: "Non-Fiction", isbn: "978-0553380163", total_copies: 2 },
  { title: "The Handmaid's Tale", author: "Margaret Atwood", genre: "Dystopian", isbn: "978-0385490818", total_copies: 3 },
  { title: "Gone Girl", author: "Gillian Flynn", genre: "Mystery", isbn: "978-0307588371", total_copies: 2 },
  { title: "The Road", author: "Cormac McCarthy", genre: "Fiction", isbn: "978-0307387899", total_copies: 2 },
  { title: "Becoming", author: "Michelle Obama", genre: "Biography", isbn: "978-1524763138", total_copies: 4 },
]

books = books_data.map { |data| Book.create!(data) }

puts "Creating borrowings..."

# Active borrowings (not yet due)
create_borrowing = ->(user, book, days_ago) {
  Borrowing.create!(
    user: user,
    book: book,
    borrowed_at: days_ago.days.ago,
    due_date: Date.current + (14 - days_ago).days
  )
}

# Active borrowings
create_borrowing.call(members[0], books[0], 3)   # member1 borrowed Great Gatsby 3 days ago
create_borrowing.call(members[0], books[3], 5)   # member1 borrowed The Hobbit 5 days ago
create_borrowing.call(members[1], books[1], 2)   # member2 borrowed Mockingbird 2 days ago
create_borrowing.call(members[2], books[4], 7)   # member3 borrowed Dune 7 days ago
create_borrowing.call(members[3], books[6], 1)   # member4 borrowed Catcher in the Rye 1 day ago

# Due today
Borrowing.create!(
  user: members[1],
  book: books[7],
  borrowed_at: 14.days.ago,
  due_date: Date.current
)

# Overdue borrowings
Borrowing.create!(
  user: members[0],
  book: books[9],
  borrowed_at: 21.days.ago,
  due_date: 7.days.ago.to_date
)

Borrowing.create!(
  user: members[2],
  book: books[10],
  borrowed_at: 18.days.ago,
  due_date: 4.days.ago.to_date
)

Borrowing.create!(
  user: members[4],
  book: books[11],
  borrowed_at: 20.days.ago,
  due_date: 6.days.ago.to_date
)

# Returned borrowings
Borrowing.create!(
  user: members[0],
  book: books[2],
  borrowed_at: 30.days.ago,
  due_date: 16.days.ago.to_date,
  returned_at: 18.days.ago
)

Borrowing.create!(
  user: members[1],
  book: books[5],
  borrowed_at: 25.days.ago,
  due_date: 11.days.ago.to_date,
  returned_at: 12.days.ago
)

Borrowing.create!(
  user: members[3],
  book: books[8],
  borrowed_at: 20.days.ago,
  due_date: 6.days.ago.to_date,
  returned_at: 8.days.ago
)

puts ""
puts "=" * 50
puts "Seed complete!"
puts "=" * 50
puts ""
puts "Users: #{User.count} (#{User.librarian.count} librarians, #{User.member.count} members)"
puts "Books: #{Book.count}"
puts "Borrowings: #{Borrowing.count} (#{Borrowing.active.count} active, #{Borrowing.overdue.count} overdue, #{Borrowing.returned.count} returned)"
puts ""
puts "Librarian login: librarian@library.com / password123"
puts "Member login:    member1@example.com / password123"
puts "=" * 50
