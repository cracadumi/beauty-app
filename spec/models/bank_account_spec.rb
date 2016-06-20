require 'rails_helper'

describe BankAccount, type: :model do
  let(:user) { create :user }
  let(:settings_beautician) { create :settings_beautician, user: user }
  subject { build :bank_account, settings_beautician: settings_beautician }

  it 'is valid' do
    expect(subject).to be_valid
  end

  it 'not valid without settings_beautician' do
    subject.settings_beautician = nil

    expect(subject).not_to be_valid
  end
end

# == Schema Information
#
# Table name: bank_accounts
#
#  id                     :integer          not null, primary key
#  settings_beautician_id :integer
#  bank_code              :integer
#  branch_number          :integer
#  account_number         :integer
#  rib_key                :integer
#  iban                   :integer
#  bic                    :integer
#  account_holder_name    :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_bank_accounts_on_settings_beautician_id  (settings_beautician_id)
#
