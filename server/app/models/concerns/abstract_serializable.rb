# frozen_string_literal: true

module AbstractSerializable
  extend ActiveSupport::Concern

  included do
    def serialize(pattern)
      return self.map { |resource| self.class.send(pattern, resource) } if self.respond_to?(:to_a)

      self.class.send(pattern, self)
    end
  end

  class_methods do
    def serialize(pattern)
      all.map { |resource| self.send(pattern, resource) }
    end
  end
end
