class Service < ActiveRecord::Base
  belongs_to :user
  belongs_to :sub_category
  belongs_to :category, though: :sub_category
  has_and_belongs_to_many :bookings
  has_many :reviews, through: :bookings
  has_many :pictures, through: :picturable

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
#  price           :decimal(8, 2)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_services_on_sub_category_id  (sub_category_id)
#  index_services_on_user_id          (user_id)
#
