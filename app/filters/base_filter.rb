class BaseFilter
  attr_reader :params

  def initialize(params)
    @params = params
  end
  def self.call(params)
    new(params).call
  end
end