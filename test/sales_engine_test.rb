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

  def test_merchant_items_method_returns_all_items_for_merchant_id
    test_engine.merchant_repository.find_by_id(1)

  end
end
