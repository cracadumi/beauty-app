FactoryGirl.define do
  factory :availability do
    day 'monday'
    starts_at '09:00'
    ends_at '18:00'
    working_day true
  end
end
