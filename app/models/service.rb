class Service < ActiveRecord::Base
  belongs_to :user
  belongs_to :sub_category
  has_one :category, through: :sub_category
  has_and_belongs_to_many :bookings
  has_many :reviews, through: :bookings
  has_many :pictures, through: :picturable

  validates :user, presence: true
  validates :sub_category, presence: true

  delegate :name, to: :sub_category

  scope :active, -> { where user_id: User.beauticians.active.pluck(:id) }
  scope :of_category, lambda { |category_id|
    where sub_category_id: Category.find_by!(id: category_id).sub_categories
      .pluck(:id)
  }
  scope :with_min_rating, lambda { |min_rating|
    where user_id: User.where('users.rating >= ?', min_rating).pluck(:id)
  }
  scope :nearest, lambda { |lat, lng, distance|
    where user_id: User.recently_tracked.nearest(lat, lng, distance).map(&:id)
  }
  scope :with_max_price, lambda { |max_price|
    where 'services.price <= ?', max_price
  }

  after_save :update_users_min_price
  after_destroy :update_users_min_price

  def update_users_min_price
    user.update_min_price!
  end
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
