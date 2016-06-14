require 'rails_helper'

describe Category, type: :model do
  let(:category) { create :category }
  subject { build :sub_category, category: category }

  it 'is valid' do
    expect(subject).to be_valid
  end

  it 'not valid without name' do
    subject.name = nil

    expect(subject).not_to be_valid
  end

  it 'not valid without category' do
    subject.category = nil

    expect(subject).not_to be_valid
  end
end

# == Schema Information
#
# Table name: sub_categories
#
#  id          :integer          not null, primary key
#  category_id :integer
#  name        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_sub_categories_on_category_id  (category_id)
#
