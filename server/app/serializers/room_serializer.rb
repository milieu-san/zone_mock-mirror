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
class RoomSerializer < AbstractSerializer
  def key
    :room
  end

  def base(room)
    {
      id: room.id,
      is_accepted_audio: room.is_accepted_audio,
      is_accepted_camera: room.is_accepted_camera,
      is_accepted_chat: room.is_accepted_chat,
      capacity: room.capacity,
      owner_id: room.owner_id
    }
  end

  def own_room(room)
    {
      id: room.id,
      is_accepted_audio: room.is_accepted_audio,
      is_accepted_camera: room.is_accepted_camera,
      is_accepted_chat: room.is_accepted_chat,
      capacity: room.capacity,
      is_private: room.is_private
    }
  end
end
