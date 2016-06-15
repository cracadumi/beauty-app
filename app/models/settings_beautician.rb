class SettingsBeautician < ActiveRecord::Base
  belongs_to :user
  has_one :office_address, as: :addressable, class_name: 'Address',
          dependent: :destroy
  has_many :availabilities, dependent: :destroy

  accepts_nested_attributes_for :office_address

  validates :user_id, presence: true

  def self.collection_for_admin
    order(:user_id, :id).map { |u| ["#{u.user.name}. #{u.id}", u.id] }
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
