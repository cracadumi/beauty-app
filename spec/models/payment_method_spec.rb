require 'rails_helper'

describe PaymentMethod, type: :model do
  let(:user) { create :user }
  subject { build :payment_method, user: user }

  it 'is valid' do
    expect(subject).to be_valid
  end

  it 'not valid without user' do
    subject.user = nil

    expect(subject).not_to be_valid
  end
end

# == Schema Information
#
# Table name: payment_methods
#
#  id            :integer          not null, primary key
#  user_id       :integer
#  payment_type  :integer          default(0), not null
#  last_4_digits :integer
#  card_type     :integer
#  default       :boolean          default(FALSE), not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_payment_methods_on_user_id  (user_id)
#
