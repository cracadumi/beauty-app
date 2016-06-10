class Address < ActiveRecord::Base
  belongs_to :addressable, polymorphic: true

  validates :addressable, presence: true
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
#
# Indexes
#
#  index_addresses_on_addressable_type_and_addressable_id  (addressable_type,addressable_id)
#

# rubocop:enable Metrics/LineLength
