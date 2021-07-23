# frozen_string_literal: true

class AbstractUsecase
  include ActiveModel::Model

  attr_reader :response_body,
              :error_message

  def invoke
    execute
    true
  rescue StandardError => e
    Rails.logger.error(e.message)
    Rails.logger.error(e.backtrace.join("\n"))
    @error_message = { errors: e.message }
    false
  end

  def execute
    raise NotImplementedError
  end

  private

  def response_data
    raise NotImplementedError
  end

  def set_response_body
    @response_body = dump_to_json(response_data)
  end

  def dump_to_json(data)
    Oj.dump(data, mode: :compat)
  end
end
