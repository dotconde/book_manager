require "rails_helper"

RSpec.describe User, type: :model do
  describe "validations" do
    it "is valid with valid attributes" do
      expect(build(:user)).to be_valid
    end

    it "is invalid without an email" do
      expect(build(:user, email: nil)).not_to be_valid
    end

    it "is invalid with a duplicate email" do
      create(:user, email: "test@example.com")
      expect(build(:user, email: "test@example.com")).not_to be_valid
    end

    it "is invalid without a first_name" do
      expect(build(:user, first_name: nil)).not_to be_valid
    end

    it "is invalid without a last_name" do
      expect(build(:user, last_name: nil)).not_to be_valid
    end
  end

  describe "enums" do
    it "defines member and librarian roles" do
      expect(User.roles).to eq({ "member" => 0, "librarian" => 1 })
    end
  end
end
