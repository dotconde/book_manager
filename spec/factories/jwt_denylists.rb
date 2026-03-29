FactoryBot.define do
  factory :jwt_denylist do
    jti { "MyString" }
    exp { "2026-03-29 07:14:25" }
  end
end
