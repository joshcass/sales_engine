gem 'minitest'
require 'minitest/autorun'
require 'minitest/pride'
require './lib/sales_engine'

class SalesEngineTest < Minitest::Test

  def setup
    dir = File.expand_path('test_data', __dir__)
    test_engine = SalesEngine.new(dir)
    test_engine.startup
  end

end
