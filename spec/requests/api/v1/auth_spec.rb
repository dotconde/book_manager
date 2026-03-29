require "rails_helper"

RSpec.describe "Authentication", type: :request do
  describe "POST /api/v1/signup" do
    let(:valid_params) do
      {
        user: {
          email: "newuser@example.com",
          password: "password123",
          password_confirmation: "password123",
          first_name: "John",
          last_name: "Doe",
          role: "member"
        }
      }
    end

    it "creates a new user and returns 201" do
      expect {
        post "/api/v1/signup", params: valid_params
      }.to change(User, :count).by(1)

      expect(response).to have_http_status(:created)
      expect(response.headers["Authorization"]).to be_present
    end

    it "returns 422 with invalid params" do
      post "/api/v1/signup", params: { user: valid_params[:user].merge(email: nil) }
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe "POST /api/v1/login" do
    let!(:user) { create(:user, email: "test@example.com", password: "password123") }

    it "returns 200 and JWT token" do
      post "/api/v1/login", params: { user: { email: "test@example.com", password: "password123" } }
      expect(response).to have_http_status(:ok)
      expect(response.headers["Authorization"]).to be_present
    end

    it "returns 401 with wrong password" do
      post "/api/v1/login", params: { user: { email: "test@example.com", password: "wrong" } }
      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe "DELETE /api/v1/logout" do
    let(:user) { create(:user) }

    it "returns 200 with valid token" do
      delete "/api/v1/logout", headers: auth_headers(user)
      expect(response).to have_http_status(:ok)
    end

    it "returns 401 without token" do
      delete "/api/v1/logout"
      expect(response).to have_http_status(:unauthorized)
    end
  end
end
