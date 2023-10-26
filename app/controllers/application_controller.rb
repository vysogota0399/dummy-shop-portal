class ApplicationController < ActionController::Base
  before_action :initialize_request

  def initialize_request
    Thread.current[:orchestrator_adapter] = Adapters::Orchestrator.new
    Thread.current[:request_id] = request.request_id
  end
end
