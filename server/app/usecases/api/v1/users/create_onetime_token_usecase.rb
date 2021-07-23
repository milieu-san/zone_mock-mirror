# frozen_string_literal: true

module Api
  module V1
    module Users
      class CreateOnetimeTokenUsecase < AbstractUsecase
        attr_reader :token

        def initialize(user:)
          @user = user
        end

        def execute
          @token = @user.set_onetime_token!

          set_response_body

          self
        end

        private

        def response_data
          {
            user: @user.serialize(:simple)
          }
        end
      end
    end
  end
end
