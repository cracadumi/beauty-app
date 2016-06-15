class Service < ActiveRecord::Base
  belongs_to :user
  belongs_to :sub_category

  validates :user, presence: true
  validates :sub_category, presence: true

  delegate :name, to: :sub_category
end

# == Schema Information
#
# Table name: services
#
#  id              :integer          not null, primary key
#  user_id         :integer
#  sub_category_id :integer
#  price           :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_services_on_sub_category_id  (sub_category_id)
#  index_services_on_user_id          (user_id)
#
