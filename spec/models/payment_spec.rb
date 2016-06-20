require 'rails_helper'

describe Payment, type: :model do
  let(:user) { create :user }
  let(:beautician) { create :user }
  let(:service) { create :service }
  let(:booking) do
    create :booking, user: user, beautician: beautician, services: [service]
  end
  subject { build :payment, user: user, booking: booking }

  it 'is valid' do
    expect(subject).to be_valid
  end

  it 'not valid without user' do
    subject.user = nil

    expect(subject).not_to be_valid
  end

  it 'not valid without booking' do
    subject.booking = nil

    expect(subject).not_to be_valid
  end
end

# == Schema Information
#
# Table name: payments
#
#  id                :integer          not null, primary key
#  booking_id        :integer
#  user_id           :integer
#  payment_method_id :integer
#  paid_at           :datetime
#  amount            :decimal(8, 2)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
# Indexes
#
#  index_payments_on_booking_id         (booking_id)
#  index_payments_on_payment_method_id  (payment_method_id)
#  index_payments_on_user_id            (user_id)
#
