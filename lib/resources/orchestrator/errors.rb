# frozen_string_literal: true

module Orchestrator
  module Errors
    class BadRequest < StandardError; end
    class InternalServerError < StandardError; end
  end
end