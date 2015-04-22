gem 'minitest'
require 'minitest/autorun'
require 'minitest/pride'
require './lib/invoices_repository'

class InvoiceRepositoryTest < Minitest::Test

  def setup
    @result = InvoiceRepository.new('./test/invoices_test_data.csv')
  end

  def test_can_initialize_with_a_data_file
    assert @result.is_a?InvoiceRepository
  end

  def test_all_returns_all_instances
    assert_equal 9, @result.invoices.count
  end

  def test_random_returns_a_random_sample_from_the_repository
    assert @result.invoices.include?@result.random
  end

  def test_find_a_invoice_by_id
    invoice = @result.find_by_id(6)
    assert_equal 1, invoice.customer_id
    assert_equal 76, invoice.merchant_id
  end

  def test_find_a_invoice_by_customer_id
    invoice = @result.find_by_customer_id(2)
    assert_equal 9, invoice.id
    assert_equal 27, invoice.merchant_id
  end

  def test_find_an_invoice_by_merchant_id
    invoice = @result.find_by_merchant_id(33)
    assert_equal 4, invoice.id
    assert_equal 1, invoice.customer_id
  end

  def test_find_a_invoice_by_created_at
    invoice = @result.find_by_created_at("2012-03-07 19:54:10 UTC")
    assert_equal 5, invoice.id
    assert_equal 1, invoice.customer_id
  end

  def test_find_by_updated_at
    invoice = @result.find_by_updated_at("2012-03-07 12:54:10 UTC")
    assert_equal 9, invoice.id
    assert_equal 2, invoice.customer_id
  end

  #TODO write more tests
end
