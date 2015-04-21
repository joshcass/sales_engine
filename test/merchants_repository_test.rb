gem 'minitest'
require 'minitest/autorun'
require 'minitest/pride'
require './lib/merchants_repository'

class MerchantRepositoryTest < Minitest::Test

  def setup
    @result = MerchantRepository.new('./test/merchants_test_data.csv')
  end

  def test_can_initialize_with_a_data_file
    assert @result.is_a?MerchantRepository
  end

  def test_all_returns_all_instances
    assert_equal 3, @result.merchants.count
  end

  def test_random_returns_a_random_sample_from_the_repository
    assert @result.merchants.include?@result.random
  end

  def test_find_a_merchant_by_id
    merchant = @result.find_by_id(1)
    assert_equal "Schroeder-Jerde", merchant.name
  end

  def test_find_a_merchant_by_name
    merchant = @result.find_by_name("Schroeder-Jerde")
    assert_equal 1, merchant.id
  end

  def test_find_a_merchant_by_created_at
    merchant = @result.find_by_created_at("2012-03-27 14:53:59 UTC")
    assert_equal 1, merchant.id
    assert_equal "Schroeder-Jerde", merchant.name
  end

  def test_find_by_updated_at
    merchant = @result.find_by_updated_at("2012-03-27 14:53:59 UTC")
    assert_equal 1, merchant.id
    assert_equal "Schroeder-Jerde", merchant.name
  end

  #TODO write more tests
end
