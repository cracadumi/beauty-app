require 'rails_helper'

describe Address, type: :model do
  let(:user) { create :user }
  let(:settings_beautician) { create :settings_beautician, user: user }
  subject { build :address, addressable: settings_beautician }

  it 'is valid' do
    expect(subject).to be_valid
  end

  it 'not valid without addressable' do
    subject.addressable = nil

    expect(subject).not_to be_valid
  end
end

# rubocop:disable Metrics/LineLength

# == Schema Information
#
# Table name: addresses
#
#  id               :integer          not null, primary key
#  addressable_id   :integer
#  addressable_type :string
#  street           :string
#  postcode         :integer
#  city             :string
#  state            :string
#  latitude         :float
#  longitude        :float
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
# Indexes
#
#  index_addresses_on_addressable_type_and_addressable_id  (addressable_type,addressable_id)
#

# rubocop:enable Metrics/LineLength
