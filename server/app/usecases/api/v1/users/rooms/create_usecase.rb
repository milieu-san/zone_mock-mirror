# frozen_string_literal: true

module Api
  module V1
    module Users
      module Rooms
        class CreateUsecase < AbstractUsecase
          def initialize(current_user:, room_attr:, user_ids:)
            @current_user = current_user
            @room_attr = room_attr
            @user_ids = user_ids
          end

          def execute
            ActiveRecord::Base.transaction(joinable: false, requires_new: true) do
              own_room.save!

              @user_ids.each do |user_id|
                own_room.subscriptions.create!(user_id: user_id)
              end
            end

            self
          end

          private

          def own_room
            return @own_room if @own_room

            @own_room = @current_user.own_rooms.new(@room_attr)
          end
        end
      end
    end
  end
end
