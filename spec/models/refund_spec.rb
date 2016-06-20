require 'rails_helper'

describe Refund, type: :model do
  let(:user) { create :user }
  let(:beautician) { create :user }
  let(:service) { create :service }
  let(:booking) do
    create :booking, user: user, beautician: beautician, services: [service]
  end
  subject { build :refund, booking: booking }

  it 'is valid' do
    expect(subject).to be_valid
  end

  it 'not valid without booking' do
    subject.booking = nil

    expect(subject).not_to be_valid
  end
end

# == Schema Information
#
# Table name: refunds
#
#  id                           :integer          not null, primary key
#  booking_id                   :integer
#  refunded_at                  :datetime
#  amount_refunded_to_performer :decimal(8, 2)
#  amount_refunded_to_customer  :decimal(8, 2)
#  created_at                   :datetime         not null
#  updated_at                   :datetime         not null
#
# Indexes
#
#  index_refunds_on_booking_id  (booking_id)
#
