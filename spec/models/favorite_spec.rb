require 'rails_helper'

describe Favorite, type: :model do
  let(:user) { create :user }
  let(:beautician) { create :user }
  subject { build :favorite, user: user, beautician: beautician }

  it 'is valid' do
    expect(subject).to be_valid
  end

  it 'not valid without user' do
    subject.user = nil

    expect(subject).not_to be_valid
  end

  it 'not valid without beautician' do
    subject.beautician = nil

    expect(subject).not_to be_valid
  end
end

# == Schema Information
#
# Table name: favorites
#
#  id            :integer          not null, primary key
#  user_id       :integer
#  beautician_id :integer
#
# Indexes
#
#  index_favorites_on_beautician_id  (beautician_id)
#  index_favorites_on_user_id        (user_id)
#
