FactoryGirl.define do
  factory :payment do
    paid_at { Time.zone.now }
    amount 155.50
  end
end
