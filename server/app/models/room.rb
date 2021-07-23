# frozen_string_literal: true

# == Schema Information
#
# Table name: rooms
#
#  id                 :bigint           not null, primary key
#  capacity           :integer          not null
#  finish_at          :datetime
#  is_accepted_audio  :boolean          default(TRUE), not null
#  is_accepted_camera :boolean          default(TRUE), not null
#  is_accepted_chat   :boolean          default(TRUE), not null
#  is_private         :boolean          default(FALSE), not null
#  start_at           :datetime
#  uuid               :string(255)      not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  owner_id           :bigint           not null
#
# Indexes
#
#  idx_rooms_01  (owner_id)
#  idx_rooms_02  (uuid)
#
# Foreign Keys
#
#  fk_rooms_01  (owner_id => users.id)
#
class Room < ApplicationRecord
  include RoomSerializable
  belongs_to :owner, class_name: 'User'
  has_many :subscriptions, dependent: :destroy
  has_many :users, through: :subscriptions

  before_validation :set_uuid

  validates :uuid, presence: true
  validates :is_accepted_audio, inclusion: { in: [true, false] }
  validates :is_accepted_camera, inclusion: { in: [true, false] }
  validates :is_accepted_chat, inclusion: { in: [true, false] }
  validates :is_private, inclusion: { in: [true, false] }
  validates :capacity, numericality: { greater_than: 0, less_than_or_equal_to: 16 }
  validate :verify_period

  scope :only_public, -> { where(is_private: false) }

  def set_uuid
    return if self.uuid.present?

    self.uuid = SecureRandom.alphanumeric(36)
  end

  def verify_period
    return if start_at.nil? || finish_at.nil?
    return if start_at < finish_at

    errors.add(:finish_at, 'must be after start_time')
  end
end
