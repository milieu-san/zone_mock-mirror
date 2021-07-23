# frozen_string_literal: true

module Api
  module V1
    module Users
      class SearchAllUsecase < AbstractUsecase
        PER = 36

        def initialize(current_user:, query:, page:)
          @current_user = current_user
          @query = query
          @page = page
        end

        def execute
          set_users

          set_response_body

          self
        end

        private

        def set_users
          @users = User
                     .where.not(id: @current_user)
                     .page(@page)
                     .per(PER)

          @users = @users.where('name like ?', "%#{@query}%") if @query.present?
        end

        def response_data
          {
            users: @users.serialize(:simple),
            total_page: @users.total_pages,
            following_ids: @current_user.followings.ids,
            follower_ids:  @current_user.followers.ids
          }
        end
      end
    end
  end
end
