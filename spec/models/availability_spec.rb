require 'rails_helper'

describe Availability, type: :model do
  let(:user) { create :user }
  let(:settings_beautician) { create :settings_beautician, user: user }
  subject { build :availability, settings_beautician: settings_beautician }

  it 'is valid' do
    expect(subject).to be_valid
  end

  describe '#starts_at_time' do
    it 'returns formatted time' do
      expect(subject.starts_at_time).to eq('09:00')
    end
  end

  describe '#ends_at_time' do
    it 'returns formatted time' do
      expect(subject.ends_at_time).to eq('18:00')
    end
  end
end

# rubocop:disable Metrics/LineLength
# == Schema Information
#
# Table name: availabilities
#
#  id                     :integer          not null, primary key
#  settings_beautician_id :integer
#  day                    :integer
#  starts_at              :time             default(2000-01-01 09:00:00 UTC), not null
#  ends_at                :time             default(2000-01-01 17:00:00 UTC), not null
#  working_day            :boolean          default(TRUE), not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_availabilities_on_settings_beautician_id  (settings_beautician_id)
#

# rubocop:enable Metrics/LineLength
