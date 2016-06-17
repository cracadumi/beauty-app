require 'rails_helper'

describe Service, type: :model do
  let(:user) { create :user }
  let(:category) { create :category }
  let(:category) { create :category }
  let(:sub_category) { create :sub_category, category: category }
  subject { build :service, user: user, sub_category: sub_category }

  it 'is valid' do
    expect(subject).to be_valid
  end

  it 'not valid without user' do
    subject.user = nil

    expect(subject).not_to be_valid
  end

  it 'not valid without sub_category' do
    subject.sub_category = nil

    expect(subject).not_to be_valid
  end
end

# == Schema Information
#
# Table name: services
#
#  id              :integer          not null, primary key
#  user_id         :integer
#  sub_category_id :integer
#  price           :decimal(8, 2)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_services_on_sub_category_id  (sub_category_id)
#  index_services_on_user_id          (user_id)
#
