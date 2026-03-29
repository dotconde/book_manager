FactoryBot.define do
  factory :borrowing do
    user { nil }
    book { nil }
    borrowed_at { "2026-03-29 07:14:26" }
    due_date { "2026-03-29" }
    returned_at { "2026-03-29 07:14:26" }
  end
end
