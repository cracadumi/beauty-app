FactoryGirl.define do
  factory :bank_account do
    bank_code '123'
    branch_number '123'
    account_number '12345678901234'
    rib_key '123'
    iban '123'
    bic '123123'
    account_holder_name 'Alex Pushkin'
  end
end
