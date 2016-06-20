require 'rails_helper'

describe Review, type: :model do
  let(:user) { create :user }
  let(:author) { create :user }
  let(:beautician) { create :user }
  let(:service) { create :service }
  let(:booking) do
    create :booking, user: user, beautician: beautician, services: [service]
  end
  subject { build :review, user: user, booking: booking, author: author }

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

  it 'not valid without author' do
    subject.author = nil

    expect(subject).not_to be_valid
  end
end

# == Schema Information
#
# Table name: reviews
#
#  id         :integer          not null, primary key
#  booking_id :integer
#  user_id    :integer
#  rating     :integer          default(1), not null
#  comment    :text
#  author_id  :integer
#  visible    :boolean          default(TRUE), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_reviews_on_author_id   (author_id)
#  index_reviews_on_booking_id  (booking_id)
#  index_reviews_on_user_id     (user_id)
#
