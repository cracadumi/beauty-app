class BankAccount < ActiveRecord::Base
  belongs_to :settings_beautician
  has_one :address, as: :addressable, class_name: 'Address',
          inverse_of: :addressable, dependent: :destroy

  validates :settings_beautician, presence: true
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
