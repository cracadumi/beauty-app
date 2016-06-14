require 'rails_helper'

describe Language, type: :model do
  subject { build :language }

  it 'is valid' do
    expect(subject).to be_valid
  end

  it 'not valid without name' do
    subject.name = nil

    expect(subject).not_to be_valid
  end

  it 'not valid without country' do
    subject.country = nil

    expect(subject).not_to be_valid
  end
end

# == Schema Information
#
# Table name: languages
#
#  id         :integer          not null, primary key
#  name       :string
#  country    :string
#  flag_url   :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
