# frozen_string_literal: true

module Middlewares
  class SetRequestIdMiddleware
    def initialize(app)
      @app = app
    end
    
    def call(env)
      request = ActionDispatch::Request.new(env)
      Thread.current[:request_id] = request.uuid
      @app.call(env)
    end
  end
end

