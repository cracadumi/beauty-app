FactoryGirl.define do
  factory :user do
    sequence :email do |n|
      "user_#{n}@mysite.com"
    end
    password 'password'
    name 'Alex'
    sequence :username do |n|
      "@pushkin#{n}"
    end
    role :user
  end
end

# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  name                   :string
#  surname                :string
#  username               :string
#  role                   :integer          default(0), not null
#  sex                    :integer          default(3), not null
#  bio                    :text
#  phone_number           :string
#  dob_on                 :date
#  profile_picture        :string
#  active                 :boolean          default(FALSE), not null
#  archived               :boolean          default(FALSE), not null
#  latitude               :float
#  longitude              :float
#  rating                 :integer          default(0), not null
#  facebook_id            :string
#  language_id            :integer
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
