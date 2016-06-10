class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable

  mount_uploader :profile_picture, AvatarUploader

  PHONE_REGEX = /\A(?:(?:\(?(?:00|\+)([1-4]\d\d|[1-9]\d?)\)?)?[\-\.\ \\\/]?)?((?:\(?\d{1,}\)?[\-\.\ \\\/]?){0,})(?:[\-\.\ \\\/]?(?:#|ext\.?|extension|x)[\-\.\ \\\/]?(\d+))?\z/i

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

  before_validation :add_dog_to_username
  after_save :set_inactive, if: 'archived? && active?'

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
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
