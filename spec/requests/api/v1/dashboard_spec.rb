require "rails_helper"

RSpec.describe "Dashboard API", type: :request do
  describe "GET /api/v1/dashboard" do
    context "as librarian" do
      let(:librarian) { create(:user, :librarian) }

      before do
        create_list(:borrowing, 2)
        create(:borrowing, :overdue)
      end

      it "returns librarian dashboard data" do
        get "/api/v1/dashboard", headers: auth_headers(librarian)
        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)
        data = json["data"]

        expect(data["total_books"]).to eq(Book.count)
        expect(data["total_borrowed"]).to eq(Borrowing.active.count)
        expect(data["members_with_overdue"]).to be_an(Array)
      end
    end

    context "as member" do
      let(:member) { create(:user, :member) }

      before do
        create(:borrowing, user: member)
        create(:borrowing, :overdue, user: member)
      end

      it "returns member dashboard data" do
        get "/api/v1/dashboard", headers: auth_headers(member)
        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)
        data = json["data"]

        expect(data["borrowed_books"]).to be_an(Array)
        expect(data["total_borrowed"]).to eq(2)
        expect(data["overdue_count"]).to eq(1)
      end
    end
  end
end
