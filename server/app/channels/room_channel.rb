# frozen_string_literal: true

class RoomChannel < ApplicationCable::Channel
  def subscribed
    stream_from("room_channel_#{room.id}")
    ActionCable.server.broadcast("room_channel_#{room.id}", { data: params[:callId] })
  end

  def unsubscribed
    stop_all_streams
  end

  private

  def room
    own_room = current_user.own_rooms.find_by(uuid: params[:id])

    return own_room if own_room

    subscribed_room = current_user.rooms.find_by(uuid: params[:id])

    return subscribed_room if subscribed_room

    Room.only_public.find_by!(uuid: params[:id])
  end
end
