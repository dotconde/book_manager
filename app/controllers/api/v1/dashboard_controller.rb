module Api
  module V1
    class DashboardController < ApplicationController
      def index
        if current_user.librarian?
          render json: librarian_dashboard, status: :ok
        else
          render json: member_dashboard, status: :ok
        end
      end

      private

      def librarian_dashboard
        overdue_users = User.joins(:borrowings)
                            .merge(Borrowing.overdue)
                            .select("users.*, COUNT(borrowings.id) as overdue_count")
                            .group("users.id")

        {
          data: {
            total_books: Book.count,
            total_borrowed: Borrowing.active.count,
            books_due_today: Borrowing.due_today.count,
            members_with_overdue: overdue_users.map do |user|
              {
                id: user.id,
                email: user.email,
                first_name: user.first_name,
                last_name: user.last_name,
                overdue_count: user.overdue_count
              }
            end
          }
        }
      end

      def member_dashboard
        borrowings = current_user.borrowings.active.includes(:book)

        {
          data: {
            borrowed_books: borrowings.map do |b|
              {
                borrowing_id: b.id,
                book_title: b.book.title,
                book_author: b.book.author,
                due_date: b.due_date,
                overdue: b.due_date < Date.current
              }
            end,
            total_borrowed: borrowings.count,
            overdue_count: borrowings.count { |b| b.due_date < Date.current }
          }
        }
      end
    end
  end
end
