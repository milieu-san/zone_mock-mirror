# frozen_string_literal: true

# == Schema Information
#
# Table name: friendships
#
#  id          :bigint           not null, primary key
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  followee_id :bigint           not null
#  follower_id :bigint           not null
#
# Indexes
#
#  idx_friendships_01  (follower_id)
#  idx_friendships_02  (followee_id)
#  ui_friendships_01   (follower_id,followee_id) UNIQUE
#
# Foreign Keys
#
#  fk_friendships_01  (follower_id => users.id)
#  fk_friendships_02  (followee_id => users.id)
#
class Friendship < ApplicationRecord
  belongs_to :follower, class_name: 'User'
  belongs_to :followee, class_name: 'User'

  validates :follower_id, uniqueness: { scope: :followee_id }
  validate :verify_followee

  def verify_followee
    return if followee_id != follower_id

    errors.add(:followee_id, 'must not be same with follower_id')
  end
end
