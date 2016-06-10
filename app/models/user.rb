class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable

  mount_uploader :profile_picture, AvatarUploader

  PHONE_REGEX = /\A(?:(?:\(?(?:00|\+)([1-4]\d\d|[1-9]\d?)\)?)?[\-\.\ \\\/]?)?((?:\(?\d{1,}\)?[\-\.\ \\\/]?){0,})(?:[\-\.\ \\\/]?(?:#|ext\.?|extension|x)[\-\.\ \\\/]?(\d+))?\z/i

  attr_accessor :facebook_token

  enum role: { user: 0, beautician: 1, admin: 2 }
  enum sex: { male: 1, female: 2, other: 3 }

  has_many :tokens, class_name: 'Doorkeeper::AccessToken',
           foreign_key: 'resource_owner_id', dependent: :destroy

  validates :name, presence: true
  validates :surname, presence: true
  validates :username, format: {
    with: /\A@\S+\z/
  }, if: 'username.present?'
  validates :phone_number, format: {
    with: PHONE_REGEX
  }, if: 'phone_number.present?'
  validates :facebook_id, uniqueness: true, if: 'facebook_id.present?'

  before_validation :add_dog_to_username
  after_save :set_inactive, if: 'archived? && active?'
  before_validation :check_fb_token, if: 'facebook_token.present?'

  def display_name
    if name.present? || surname.present?
      return [name, surname].select(&:present?).join(' ')
    elsif username.present?
      return username
    end
    email
  end

  def full_name
    [name, surname].select(&:present?).join(' ')
  end

  def send_welcome_message
    UserMailer.welcome_beautician(id).deliver_now if beautician?
    UserMailer.welcome_user(id).deliver_now if user?
  end

  def channel
    "private-#{id}"
  end

  def verify
    errors.add(:active, 'User archived') && return if archived?
    update_attribute :active, true
    UserMailer.verified_beautician(id).deliver_now
  end

  def add_dog_to_username
    self.username = "@#{username}" if username.present? && !(username =~ /\A@/)
  end

  def set_inactive
    update_attribute :active, false if archived? && active?
  end

  def check_fb_token
    facebook = URI.parse('https://graph.facebook.com/me?access_token=' +
                             facebook_token)
    response = Net::HTTP.get_response(facebook)
    user_data = JSON.parse(response.body)
    Rails.logger.info "user_data=#{user_data.inspect}"

    if user_data['error']
      errors.add(:fb_token, user_data['error'])
    else
      self.facebook_id = user_data['id']
    end
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
