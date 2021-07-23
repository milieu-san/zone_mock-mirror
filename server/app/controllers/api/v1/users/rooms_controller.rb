# frozen_string_literal: true

module Api
  module V1
    module Users
      class RoomsController < ApplicationController
        before_action :authenticate_user!

        def index
          rooms = current_user.own_rooms

          render json: { rooms: rooms }, status: :ok
        end

        def create
          usecase = Rooms::CreateUsecase
                      .new(**create_params)
          if usecase.invoke
            render status: :created
          else
            render status: :bad_request
          end
        end

        def destroy
          room.destroy!

          render status: :no_content
        end

        private

        def room
          @room = current_user.own_rooms.find(params[:id])
        end

        def create_params
          {
            current_user: current_user,
            room_attr: {
              capacity: params[:capacity],
              start_at: params[:start_at],
              finish_at: params[:finish_at],
              is_accepted_camera: params[:is_accepted_camera],
              is_accepted_audio: params[:is_accepted_audio],
              is_accepted_chat: params[:is_accepted_chat],
              is_private: params[:is_private]
            },
            user_ids: params[:user_ids]
          }
        end
      end
    end
  end
end
