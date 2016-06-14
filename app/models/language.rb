class Language < ActiveRecord::Base
  has_many :users

  validates :name, presence: true
  validates :country, presence: true
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
