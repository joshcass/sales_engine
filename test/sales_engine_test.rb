gem 'minitest'
require 'minitest/autorun'
require 'minitest/pride'
require './lib/customer_repository'
require './lib/invoice_item_repository'
require './lib/item_repository'
require './lib/merchant_repository'
require './lib/transaction_repository'
require './lib/invoice_repository'

class SalesEngineTest < Minitest::Test

  def setup
    dir = File.expand_path('test', __dir__)

  end

end
