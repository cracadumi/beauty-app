FactoryGirl.define do
  factory :refund do
    refunded_at { Time.zone.now }
  end
end
