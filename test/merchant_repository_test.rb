gem 'minitest'
require 'minitest/autorun'
require 'minitest/pride'
require './lib/merchant_repository'

class MerchantRepositoryTest < Minitest::Test

  def setup
    @result = MerchantRepository.new(SmarterCSV.process('./test/merchant_test_data.csv'))
  end

  def test_can_initialize_with_a_data_file
    assert @result.is_a?MerchantRepository
  end

  def test_all_returns_all_instances
    assert_equal 30, @result.merchants.count
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

  def test_find_all_by_id_returns_array_of_all_objects_with_that_id
    #Aren't those supposed to be unique, though?
    assert_equal [], @result.find_all_by_id(50)
    sample_result = @result.find_all_by_id(28)
    assert sample_result.class == Array
    assert sample_result.length == 1
    assert sample_result[0].class == Merchant
    assert sample_result[0].id == 28
  end

  def test_find_all_by_name_returns_array_of_all_objects_with_that_name
    assert_equal [], @result.find_all_by_name("bob's used cars")
    sample_result = @result.find_all_by_name("Schulist, Wilkinson and Leannon")
    assert sample_result.class == Array
    assert sample_result.length == 1
    assert sample_result.all? {|merchant| merchant.class == Merchant}
    assert sample_result.all? {|merchant| merchant.name == "Schulist, Wilkinson and Leannon"}
  end

  def test_find_all_by_created_at_returns_array_of_all_objects_created_then
    assert_equal [], @result.find_all_by_created_at("2075-04-21 14:53:59 UTC")
    sample_result = @result.find_all_by_created_at("2012-03-27 14:54:00 UTC")
    assert sample_result.class == Array
    assert sample_result.length == 12
    assert sample_result.all? {|merchant| merchant.class == Merchant}
    assert sample_result.all? {|merchant| merchant.created_at == "2012-03-27 14:54:00 UTC"}
  end

  def test_find_all_by_updated_at_returns_array_of_all_objects_updated_then
    assert_equal [], @result.find_all_by_updated_at("2075-04-21 14:53:59 UTC")
    sample_result = @result.find_all_by_updated_at("2012-03-27 14:54:01 UTC")
    assert sample_result.class == Array
    assert sample_result.length == 9
    assert sample_result.all? {|merchant| merchant.class == Merchant}
    assert sample_result.all? {|merchant| merchant.updated_at == "2012-03-27 14:54:01 UTC"}
  end
end
