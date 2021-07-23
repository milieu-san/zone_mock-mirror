# frozen_string_literal: true

module Api
  module V1
    module Users
      class SubscriptionsController < ApplicationController
        before_action :authenticate_user!

        def create
          subscription = current_user.own_rooms
                           .find_by!(params[:room_id])
                           .subscriptions
                           .new(user: User.find(params[:user_id]))

          if subscription.save
            render status: :created
          else
            render status: :bad_request
          end
        end

        def destroy
          current_user.subscriptions
            .find_by!(room_id: params[:room_id])
            .destroy!

          render status: :no_content
        end
      end
    end
  end
end
