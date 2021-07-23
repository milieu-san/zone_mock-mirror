# frozen_string_literal: true

# == Schema Information
#
# Table name: subscriptions
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  room_id    :bigint           not null
#  user_id    :bigint           not null
#
# Indexes
#
#  idx_subscriptions_01  (user_id)
#  idx_subscriptions_02  (room_id)
#  ui_subscriptions_01   (user_id,room_id) UNIQUE
#
# Foreign Keys
#
#  fk_subscriptions_01  (user_id => users.id)
#  fk_subscriptions_02  (room_id => rooms.id)
#
class Subscription < ApplicationRecord
  belongs_to :user
  belongs_to :room

  validate :over_capacity

  validates :user_id, uniqueness: { scope: :room_id }

  def over_capacity
    return if room.users.count <= room.capacity

    errors.add(:user_id, 'over capacity')
  end
end
