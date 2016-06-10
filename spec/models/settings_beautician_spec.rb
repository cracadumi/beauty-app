require 'rails_helper'

describe SettingsBeautician, type: :model do
  let(:user) { create :user }
  subject { build :settings_beautician, user: user }

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
# Table name: settings_beauticians
#
#  id              :integer          not null, primary key
#  user_id         :integer
#  instant_booking :boolean          default(FALSE), not null
#  advance_booking :boolean          default(FALSE), not null
#  mobile          :boolean          default(FALSE), not null
#  office          :boolean          default(FALSE), not null
#  profession      :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_settings_beauticians_on_user_id  (user_id)
#
