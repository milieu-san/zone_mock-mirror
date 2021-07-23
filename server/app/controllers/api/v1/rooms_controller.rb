# frozen_string_literal: true

module Api
  module V1
    class RoomsController < ApplicationController
      before_action :authenticate_user!

      def index
        rooms = Room.only_public
                  .serialize(:base)

        render json: { rooms: rooms }, status: :ok
      end
    end
  end
end
