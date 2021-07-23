# frozen_string_literal: true

module Api
  module V1
    module Users
      class FriendsController < ApplicationController
        before_action :authenticate_user!

        def index
          friends = current_user.friends
                      .serialize(:simple)

          render json: { friends: friends }, status: :ok
        end
      end
    end
  end
end
