class ApplicationController < ActionController::Base
  before_action :initialize_request

  def initialize_request
    Thread.current[:orchestrator_adapter] = Adapters::Orchestrator.new
    @item_categories = Thread.current[:orchestrator_adapter].item_categories
  end
end
