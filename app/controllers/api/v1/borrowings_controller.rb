module Api
  module V1
    class BorrowingsController < ApplicationController
      before_action :set_borrowing, only: [ :return ]

      def index
        borrowings = policy_scope(Borrowing).includes(:user, :book)
        borrowings = filter_by_status(borrowings)
        borrowings = borrowings.page(params[:page]).per(params[:per_page] || 20)

        render json: BorrowingSerializer.new(
          borrowings,
          include: [ :user, :book ],
          meta: pagination_meta(borrowings)
        ).serializable_hash, status: :ok
      end

      def create
        borrowing = current_user.borrowings.new(borrowing_params)
        authorize borrowing

        if borrowing.save
          render json: BorrowingSerializer.new(
            borrowing,
            include: [ :book ]
          ).serializable_hash, status: :created
        else
          render json: { errors: borrowing.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def return
        authorize @borrowing

        if @borrowing.returned_at.present?
          render json: { errors: [ "This borrowing has already been returned" ] }, status: :unprocessable_entity
          return
        end

        @borrowing.update!(returned_at: Time.current)
        render json: BorrowingSerializer.new(
          @borrowing,
          include: [ :user, :book ]
        ).serializable_hash, status: :ok
      end

      private

      def set_borrowing
        @borrowing = Borrowing.find(params[:id])
      end

      def borrowing_params
        params.require(:borrowing).permit(:book_id)
      end

      def filter_by_status(borrowings)
        case params[:status]
        when "active"
          borrowings.active
        when "returned"
          borrowings.returned
        when "overdue"
          borrowings.overdue
        else
          borrowings
        end
      end
    end
  end
end
