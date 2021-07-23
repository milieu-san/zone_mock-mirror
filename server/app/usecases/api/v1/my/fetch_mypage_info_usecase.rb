# frozen_string_literal: true

module Api
  module V1
    module My
      class FetchMypageInfoUsecase < AbstractUsecase
        def initialize(current_user:)
          @current_user = current_user
        end

        def execute
          set_response_body

          self
        end

        private

        def response_data
          {
            current_user: @current_user.serialize(:simple),
            friends: @current_user.friends.serialize(:simple),
            own_rooms: @current_user.own_rooms.includes(:users).joins(:users).serialize(:own_room),
            rooms: @current_user.rooms.includes(:users, :owner).joins(:users, :owner).serialize(:base),
            followers: @current_user.only_followers.serialize(:simple)
          }
        end
      end
    end
  end
end
