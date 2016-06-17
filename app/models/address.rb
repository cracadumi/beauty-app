class Address < ActiveRecord::Base
  belongs_to :addressable, polymorphic: true

  geocoded_by :display_name

  validates :addressable, presence: true
  validates :street, presence: true
  validates :postcode, presence: true
  validates :city, presence: true
  validates :country, presence: true

  after_validation :geocode

  def display_name
    [postcode, street, city, state].select(&:present?).join ', '
  end

  def coordinates
    [latitude, longitude].select(&:present?).join ', '
  end
end

# rubocop:disable Metrics/LineLength

# == Schema Information
#
# Table name: addresses
#
#  id               :integer          not null, primary key
#  addressable_id   :integer
#  addressable_type :string
#  street           :string
#  postcode         :integer
#  city             :string
#  state            :string
#  latitude         :float
#  longitude        :float
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  country          :string
#
# Indexes
#
#  index_addresses_on_addressable_type_and_addressable_id  (addressable_type,addressable_id)
#

# rubocop:enable Metrics/LineLength
