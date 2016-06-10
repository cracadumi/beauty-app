class SettingsBeautician < ActiveRecord::Base
  belongs_to :user

  validates :user_id, presence: true
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
