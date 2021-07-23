# frozen_string_literal: true

module Api
  module V1
    class FriendshipsController < ApplicationController
      before_action :authenticate_user!

      # create active_follow
      def create
        active_follow = current_user.active_follows
                          .new(followee_id: params[:followee_id])

        if active_follow.save
          render status: :created
        else
          render status: :bad_request
        end
      end

      # destroy active_follow
      def destroy
        active_follow = current_user.active_follows
                          .find_by!(followee_id: params[:followee_id])

        if active_follow.destroy
          render status: :no_content
        else
          render status: :bad_request
        end
      end
    end
  end
end
