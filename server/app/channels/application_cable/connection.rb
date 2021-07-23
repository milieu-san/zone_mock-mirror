# frozen_string_literal: true

module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_verified_user
    end

    private

    def find_verified_user
      reject_unauthorized_connection if request.params[:token].nil?

      user = User.find_by(**user_params)

      if user.nil? || user.onetime_token_expired?
        reject_unauthorized_connection
        return
      end

      user.remove_onetime_token!

      user
    end

    def user_params
      { email: request.params[:uid],
        onetime_token: request.params[:token] }
    end
  end
end
