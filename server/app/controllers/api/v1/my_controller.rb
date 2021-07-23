# frozen_string_literal: true

module Api
  module V1
    class MyController < ApplicationController
      before_action :authenticate_user!

      def show
        usecase = My::FetchMypageInfoUsecase
                    .new(current_user: current_user)

        if usecase.invoke
          render json: usecase.response_body, status: :ok
        else
          render json: usecase.error_message, status: :bad_request
        end
      end
    end
  end
end
