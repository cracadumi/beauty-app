class SubCategory < ActiveRecord::Base
  belongs_to :category
  has_many :services, dependent: :destroy
  has_many :users, through: :services

  validates :category, presence: true
  validates :name, presence: true
end

# == Schema Information
#
# Table name: sub_categories
#
#  id          :integer          not null, primary key
#  category_id :integer
#  name        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_sub_categories_on_category_id  (category_id)
#
