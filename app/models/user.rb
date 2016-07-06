class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable
  reverse_geocoded_by :latitude, :longitude

  mount_base64_uploader :profile_picture, ImageUploader

  PHONE_REGEX = /\A(?:(?:\(?(?:00|\+)([1-4]\d\d|[1-9]\d?)\)?)?[\-\.\ \\\/]?)?((?:\(?\d{1,}\)?[\-\.\ \\\/]?){0,})(?:[\-\.\ \\\/]?(?:#|ext\.?|extension|x)[\-\.\ \\\/]?(\d+))?\z/i

  attr_accessor :facebook_token

  enum role: { user: 0, beautician: 1, admin: 2 }
  enum sex: { male: 1, female: 2, other: 3 }

  belongs_to :language
  has_one :settings_beautician, dependent: :destroy
  has_one :address, as: :addressable, class_name: 'Address',
          inverse_of: :addressable, dependent: :destroy
  has_many :tokens, class_name: 'Doorkeeper::AccessToken',
           foreign_key: 'resource_owner_id', dependent: :destroy
  has_many :services, dependent: :destroy
  has_many :categories, through: :services
  has_many :bookings, dependent: :destroy
  has_many :payment_methods, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many :my_reviews, dependent: :destroy, class_name: 'Review',
           foreign_key: 'author_id'
  has_many :pictures, as: :picturable, class_name: 'Picture'
  has_many :favorites, dependent: :destroy
  has_many :in_favorites, dependent: :destroy, class_name: 'Favorite',
           foreign_key: 'beautician_id'

  accepts_nested_attributes_for :settings_beautician, :address

  validates :name, :username, presence: true
  validates :username,
            format: { with: /\A@\S+\z/ },
            uniqueness: { case_sensitive: false },
            if: 'username.present?'
  validates :phone_number, format: {
    with: PHONE_REGEX
  }, if: 'phone_number.present?'
  validates :facebook_id, uniqueness: true, if: 'facebook_id.present?'

  before_validation :add_dog_to_username
  before_validation :check_fb_token, if: 'facebook_token.present?'
  after_create :create_settings_beautician, if: 'beautician?'
  after_save :set_inactive, if: 'archived? && active?'

  scope :users, -> { where role: roles[:user] }
  scope :beauticians, -> { where role: roles[:beautician] }
  scope :recently_tracked, lambda {
    where 'users.last_tracked_at >= ?', 5.minutes.ago
  }
  scope :nearest, lambda { |lat, lng, distance|
    near([lat, lng], distance, order: 'distance', units: :km)
  }
  scope :of_category, lambda { |category_id|
    where id: Category.find_by!(id: category_id).sub_categories
      .map(&:user_ids).flatten.uniq
  }
  scope :with_min_rating, lambda { |min_rating|
    where 'users.rating >= ?', min_rating
  }

  def self.collection_for_admin
    order(:id).map { |u| ["#{u.id}. #{u.display_name}", u.id] }
  end

  def recently_tracked?
    last_tracked_at.present? && last_tracked_at >= 5.minutes.ago
  end

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

  def create_settings_beautician
    settings_beautician = build_settings_beautician
    settings_beautician.save
    settings_beautician.create_office_address_from_user_address if address
    settings_beautician.create_availabilities
  end

  def in_favorites?(beautician)
    favorites.where(beautician_id: beautician.id).any?
  end

  def update_rating
    self.reviews_count = reviews.size
    self.rating = reviews.any? ? reviews.sum(:rating) / reviews.size : 0
  end

  def update_rating!
    update_rating
    save
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
#  profile_picture_url    :string
#  active                 :boolean          default(FALSE), not null
#  archived               :boolean          default(FALSE), not null
#  latitude               :float
#  longitude              :float
#  rating                 :integer          default(0), not null
#  facebook_id            :string
#  language_id            :integer
#  last_tracked_at        :datetime
#  reviews_count          :integer          default(0), not null
#  profile_picture        :string
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
