# frozen_string_literal: true

module Api
  module V1
    class UsersController < ApplicationController
      before_action :authenticate_user!

      def index
        usecase = Users::SearchAllUsecase
                    .new(**index_params)
        if usecase.invoke
          render json: usecase.response_body, status: :ok
        else
          render json: usecase.error_message, status: :bad_request
        end
      end

      def onetime_token
        usecase = Users::CreateOnetimeTokenUsecase
                    .new(user: current_user)
        if usecase.invoke
          response.headers['X-ZoneMock-WsToken'] = usecase.token
          render json: usecase.response_body, status: :ok
        else
          render json: usecase.error_message, status: :bad_request
        end
      end

      private

      def index_params
        {
          current_user: current_user,
          query: params[:query],
          page: params[:page]
        }
      end
    end
  end
end
