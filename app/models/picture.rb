class Picture < ActiveRecord::Base
  belongs_to :picturable, polymorphic: true

  validates :picturable, presence: true
  validates :picture_url, presence: true
end

# rubocop:disable Metrics/LineLength

# == Schema Information
#
# Table name: pictures
#
#  id              :integer          not null, primary key
#  picturable_id   :integer
#  picturable_type :string
#  title           :string
#  description     :text
#  picture_url     :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_pictures_on_picturable_type_and_picturable_id  (picturable_type,picturable_id)
#

# rubocop:enable Metrics/LineLength
