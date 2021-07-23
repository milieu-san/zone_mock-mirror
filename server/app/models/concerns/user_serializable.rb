# frozen_string_literal: true

module UserSerializable
  extend ActiveSupport::Concern
  include AbstractSerializable

  class_methods do
    def simple(user)
      {
        id: user.id,
        name: user.name
      }
    end
  end
end
