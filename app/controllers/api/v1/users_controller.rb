module Api
  module V1
    class UsersController < ApplicationController
      def me
        render json: UserSerializer.new(current_user).serializable_hash, status: :ok
      end
    end
  end
end
