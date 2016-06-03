class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :tokens, class_name: 'Doorkeeper::AccessToken',
                    foreign_key: 'resource_owner_id', dependent: :destroy

  def admin?
    true # TODO
  end

  # def display_name
  #   if name.present? || surname.present?
  #     return [name, surname].select(&:present?).join(' ')
  #   end
  #   email
  # end

  def send_welcome_message
    UserMailer.registered(id).deliver_now
  end

  def channel
    "private-#{id}"
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
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
