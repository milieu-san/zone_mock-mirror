# frozen_string_literal: true

module RoomSerializable
  extend ActiveSupport::Concern
  include AbstractSerializable

  class_methods do
    def base(room)
      {
        id: room.id,
        uuid: room.uuid,
        is_accepted_audio: room.is_accepted_audio,
        is_accepted_camera: room.is_accepted_camera,
        is_accepted_chat: room.is_accepted_chat,
        capacity: room.capacity,
        owner_id: room.owner_id,
        users: room.users.map { |user| User.simple(user) },
        owner: User.simple(room.owner)
      }
    end

    def own_room(room)
      {
        id: room.id,
        uuid: room.uuid,
        is_accepted_audio: room.is_accepted_audio,
        is_accepted_camera: room.is_accepted_camera,
        is_accepted_chat: room.is_accepted_chat,
        capacity: room.capacity,
        is_private: room.is_private,
        users: room.users.map { |user| User.simple(user) }
      }
    end
  end
end
