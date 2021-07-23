# frozen_string_literal: true

class AbstractSerializer < NutsJson::Serializer
  def to_hash
    return self.send(@pattern, @resource) unless @resource.respond_to?(:to_a)

    @resource.map { |data| self.send(@pattern, data) }
  end
end
