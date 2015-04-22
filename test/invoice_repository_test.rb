gem 'minitest'
require 'minitest/autorun'
require 'minitest/pride'
require 'smarter_csv'
require './lib/invoice_repository'

class InvoiceRepositoryTest < Minitest::Test

  def setup
    @result = InvoiceRepository.new(SmarterCSV.process('./test/invoice_test_data.csv'), self)
  end

  def test_can_initialize_with_a_data_file
    assert @result.is_a?InvoiceRepository
  end

  def test_all_returns_all_instances
    assert_equal 29, @result.invoices.count
  end

  def test_random_returns_a_random_sample_from_the_repository
    assert @result.invoices.include?@result.random
  end

  def test_find_a_sample_result_by_id
    sample_result = @result.find_by_id(6)
    assert_equal 1, sample_result.customer_id
    assert_equal 76, sample_result.merchant_id
  end

  def test_find_a_sample_result_by_customer_id
    sample_result = @result.find_by_customer_id(2)
    assert_equal 9, sample_result.id
    assert_equal 27, sample_result.merchant_id
  end

  def test_find_an_sample_result_by_merchant_id
    sample_result = @result.find_by_merchant_id(33)
    assert_equal 4, sample_result.id
    assert_equal 1, sample_result.customer_id
  end

  def test_find_a_sample_result_by_status
    sample_result = @result.find_by_status("shipped")
    assert_equal "shipped", sample_result.status
  end

  def test_find_a_sample_result_by_created_at
    sample_result = @result.find_by_created_at("2012-03-07 19:54:10 UTC")
    assert_equal 5, sample_result.id
    assert_equal 1, sample_result.customer_id
  end

  def test_find_a_sampe_result_by_updated_at
    sample_result = @result.find_by_updated_at("2012-03-07 12:54:10 UTC")
    assert_equal 9, sample_result.id
    assert_equal 2, sample_result.customer_id
  end

  def test_find_all_by_id_returns_array_of_all_objects_with_that_id
    #Aren't those supposed to be unique, though?
    assert_equal [], @result.find_all_by_id(135581778)
    sample_result = @result.find_all_by_id(10)
    assert sample_result.class == Array
    assert sample_result.length == 1
    assert sample_result[0].class == Invoice
    assert sample_result[0].id == 10
  end

  def test_find_all_by_customer_id_returns_array_of_all_objects_with_that_customer_id
    #Aren't those supposed to be near-unique, though?
    assert_equal [], @result.find_all_by_customer_id(10)
    sample_result = @result.find_all_by_customer_id(4)
    assert sample_result.class == Array
    assert sample_result.length == 8
    assert sample_result.all? {|item| item.class == Invoice}
    assert sample_result.all? {|item| item.customer_id == 4}
  end

  def test_find_all_by_merchant_id_returns_array_of_all_objects_with_that_merchant_id
    #Aren't those supposed to be near-unique, though?
    assert_equal [], @result.find_all_by_merchant_id(100)
    sample_result = @result.find_all_by_merchant_id(83)
    assert sample_result.class == Array
    assert sample_result.length == 4
    assert sample_result.all? {|item| item.class == Invoice}
    assert sample_result.all? {|item| item.merchant_id == 83}
  end

  def test_find_all_by_status_returns_array_of_all_objects_with_that_status
    assert_equal [], @result.find_all_by_status("not shipped")
    sample_result = @result.find_all_by_status("shipped")
    assert sample_result.class == Array
    assert sample_result.length == 29
    assert sample_result.all? { |item| item.class == Invoice}
    assert sample_result.all? { |item| item.status == "shipped"}
  end

  def test_find_all_by_created_at_returns_array_of_all_objects_created_then
    assert_equal [], @result.find_all_by_created_at("2075-04-21 14:53:59 UTC")
    sample_result = @result.find_all_by_created_at("2012-03-12 03:54:10 UTC")
    assert sample_result.class == Array
    assert sample_result.length == 4
    assert sample_result.all? { |item| item.class == Invoice}
    assert sample_result.all? { |item| item.created_at == "2012-03-12 03:54:10 UTC"}
  end

  def test_find_all_by_updated_at_returns_array_of_all_objects_updated_then
    assert_equal [], @result.find_all_by_updated_at("2075-04-21 14:53:59 UTC")
    sample_result = @result.find_all_by_updated_at("2012-03-16 13:54:11 UTC")
    assert sample_result.class == Array
    assert sample_result.length == 4
    assert sample_result.all? { |item| item.class == Invoice}
    assert sample_result.all? { |item| item.updated_at == "2012-03-16 13:54:11 UTC"}
  end

end
