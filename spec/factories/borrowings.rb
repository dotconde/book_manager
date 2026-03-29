FactoryBot.define do
  factory :borrowing do
    association :user, :member
    association :book
    borrowed_at { Time.current }
    due_date { Date.current + 14.days }
    returned_at { nil }

    trait :returned do
      returned_at { Time.current }
    end

    trait :overdue do
      borrowed_at { 3.weeks.ago }
      due_date { 1.week.ago.to_date }
    end
  end
end
