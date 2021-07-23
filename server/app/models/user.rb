# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                       :bigint           not null, primary key
#  allow_password_change    :boolean          default(FALSE)
#  confirmation_sent_at     :datetime
#  confirmation_token       :string(255)
#  confirmed_at             :datetime
#  current_sign_in_at       :datetime
#  current_sign_in_ip       :string(255)
#  email                    :string(255)      not null
#  encrypted_password       :string(255)      default(""), not null
#  last_sign_in_at          :datetime
#  last_sign_in_ip          :string(255)
#  name                     :string(255)      not null
#  onetime_token            :string(255)
#  onetime_token_created_at :datetime
#  provider                 :string(255)      default("email"), not null
#  remember_created_at      :datetime
#  reset_password_sent_at   :datetime
#  reset_password_token     :string(255)
#  sign_in_count            :integer          default(0), not null
#  tokens                   :text(65535)
#  uid                      :string(255)      default(""), not null
#  unconfirmed_email        :string(255)
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#
# Indexes
#
#  ui_users_01  (name) UNIQUE
#  ui_users_02  (email) UNIQUE
#  ui_users_03  (uid,provider) UNIQUE
#  ui_users_04  (reset_password_token) UNIQUE
#  ui_users_05  (confirmation_token) UNIQUE
#
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  include DeviseTokenAuth::Concerns::User
  include UserSerializable

  has_many :own_rooms,
           class_name: 'Room',
           inverse_of: :owner,
           foreign_key: :owner_id,
           dependent: :destroy
  has_many :subscriptions, dependent: :destroy
  has_many :rooms, through: :subscriptions
  has_many :active_follows,
           class_name: 'Friendship',
           inverse_of: :follower,
           foreign_key: :follower_id,
           dependent: :destroy
  has_many :passive_follows,
           class_name: 'Friendship',
           inverse_of: :followee,
           foreign_key: :followee_id,
           dependent: :destroy
  has_many :followings, through: :active_follows, source: :followee
  has_many :followers, through: :passive_follows, source: :follower

  validates :name, presence: true, length: { maximum: 255 }
  validates :email, presence: true

  def follow(user)
    active_follows.create(followee: user)
  end

  # only followers, except friends
  def only_followers
    followers.where.not(id: friends)
  end

  def friends
    followings.joins(:active_follows).where(active_follows: { followee_id: id })
  end

  def set_onetime_token!
    token = SecureRandom.alphanumeric(22)
    update!(onetime_token: token, onetime_token_created_at: Time.zone.now)
    token
  end

  def onetime_token_expired?
    onetime_token.nil? || (Time.zone.now - onetime_token_created_at) > 5.minutes
  end

  def remove_onetime_token!
    update!(onetime_token: nil, onetime_token_created_at: nil)
  end
end
