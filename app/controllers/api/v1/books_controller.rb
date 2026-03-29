module Api
  module V1
    class BooksController < ApplicationController
      before_action :set_book, only: [ :show, :update, :destroy ]

      def index
        books = policy_scope(Book).search(params[:search])
                                  .page(params[:page])
                                  .per(params[:per_page] || 20)

        render json: BookSerializer.new(books, meta: pagination_meta(books)).serializable_hash,
               status: :ok
      end

      def show
        authorize @book
        render json: BookSerializer.new(@book).serializable_hash, status: :ok
      end

      def create
        book = Book.new(book_params)
        authorize book

        if book.save
          render json: BookSerializer.new(book).serializable_hash, status: :created
        else
          render json: { errors: book.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        authorize @book

        if @book.update(book_params)
          render json: BookSerializer.new(@book).serializable_hash, status: :ok
        else
          render json: { errors: @book.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        authorize @book
        @book.destroy
        head :no_content
      end

      private

      def set_book
        @book = Book.find(params[:id])
      end

      def book_params
        params.require(:book).permit(:title, :author, :genre, :isbn, :total_copies)
      end
    end
  end
end
