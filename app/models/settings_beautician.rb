class SettingsBeautician < ActiveRecord::Base
  belongs_to :user
  has_one :office_address, as: :addressable, class_name: 'Address',
          dependent: :destroy
  has_one :bank_account
  has_many :availabilities, dependent: :destroy

  accepts_nested_attributes_for :office_address

  validates :user_id, presence: true

  def self.collection_for_admin
    order(:user_id, :id).map { |u| ["#{u.user.name}. #{u.id}", u.id] }
  end

  def create_office_address_from_user_address
    address_attributes = user.address.attributes.reject do |k|
      %w(id addressable_id addressable_type).include? k
    end
    build_office_address(address_attributes).save
    create_availabilities
  end

  def create_availabilities
    Date::DAYNAMES.each do |week_day|
      availabilities_param = { day: week_day.downcase, starts_at: '09:00',
                               ends_at: '17:00' }
      availabilities.create availabilities_param
    end
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
