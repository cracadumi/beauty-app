require 'rails_helper'

describe Picture, type: :model do
  let(:user) { create :user }
  subject { build :picture, picturable: user }

  it 'is valid' do
    expect(subject).to be_valid
  end

  it 'not valid without picturable' do
    subject.picturable = nil

    expect(subject).not_to be_valid
  end

  it 'not valid without picture_url' do
    subject.picture_url = nil

    expect(subject).not_to be_valid
  end
end

# rubocop:disable Metrics/LineLength
# == Schema Information
#
# Table name: pictures
#
#  id              :integer          not null, primary key
#  picturable_id   :integer
#  picturable_type :string
#  title           :string
#  description     :text
#  picture_url     :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_pictures_on_picturable_type_and_picturable_id  (picturable_type,picturable_id)
#

# rubocop:enable Metrics/LineLength
