class Availability < ActiveRecord::Base
  enum day: { sunday: 0, monday: 1, tuesday: 2, wednesday: 3, thursday: 4,
              friday: 5, saturday: 6 }

  belongs_to :settings_beautician
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
