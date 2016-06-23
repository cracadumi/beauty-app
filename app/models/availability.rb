class Availability < ActiveRecord::Base
  enum day: { sunday: 0, monday: 1, tuesday: 2, wednesday: 3, thursday: 4,
              friday: 5, saturday: 6 }

  belongs_to :settings_beautician

  validates :day, uniqueness: { scope: :settings_beautician_id }

  def starts_at_time
    starts_at.strftime('%H:%M') if starts_at
  end

  def ends_at_time
    ends_at.strftime('%H:%M') if ends_at
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
