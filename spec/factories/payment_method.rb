FactoryGirl.define do
  factory :payment_method do
    payment_type :card
    card_type :visa
  end
end
