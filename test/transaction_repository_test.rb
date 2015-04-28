gem 'minitest'
require 'minitest/autorun'
require 'minitest/pride'
require './lib/transaction_repository'

class TransactionRepositoryTest < Minitest::Test

  def setup
    @result = TransactionRepository.new(SmarterCSV.process('./test_data/transactions.csv'), self)
  end

  def test_can_initialize_with_a_data_file
    assert @result.is_a?TransactionRepository
  end

  def test_all_returns_all_instances
    assert_equal 32, @result.transactions.count
  end

  def test_random_returns_a_random_transaction
    assert @result.transactions.include?@result.random
  end

  def test_find_a_sample_result_by_id
    sample_result = @result.find_by_id(10)
    assert_equal "4923661117104166", sample_result.credit_card_number
    assert_equal 11, sample_result.invoice_id
  end

  def test_find_a_sample_result_by_invoice_id
    sample_result = @result.find_by_invoice_id(15)
    assert_equal 16, sample_result.id
    assert_equal "4738848761455352", sample_result.credit_card_number
  end

  def test_find_an_sample_result_by_credit_card_number
    sample_result = @result.find_by_credit_card_number("4822758023695469")
    assert_equal 23, sample_result.id
    assert_equal 22, sample_result.invoice_id
  end

  def test_find_a_sample_result_by_credit_card_expiration_date
    sample_result = @result.find_by_credit_card_expiration_date("11/17")
    assert_equal 5, sample_result.id
    assert_equal 6, sample_result.invoice_id
  end

  def test_find_a_sample_result_by_result
    sample_result = @result.find_by_result("success")
    assert_equal "success", sample_result.result
  end

  def test_find_a_sample_result_by_created_at
    sample_result = @result.find_by_created_at("2012-03-27 14:00:10 UTC")
    assert_equal 17, sample_result.id
    assert_equal 16, sample_result.invoice_id
  end

  def test_find_a_sampe_result_by_updated_at
    sample_result = @result.find_by_updated_at("2012-03-27 14:00:10 UTC")
    assert_equal 20, sample_result.id
    assert_equal 19, sample_result.invoice_id
  end

  def test_find_all_by_id_returns_array_of_all_objects_with_that_id
    #Aren't those supposed to be unique, though?
    assert_equal [], @result.find_all_by_id(50)
    sample_result = @result.find_all_by_id(28)
    assert sample_result.class == Array
    assert_equal 1, sample_result.length
    assert sample_result[0].class == Transaction
    assert sample_result[0].id == 28
  end

  def test_find_all_by_invoice_id_returns_array_of_all_objects_with_that_invoice_id
    assert_equal [], @result.find_all_by_invoice_id(50)
    sample_result = @result.find_all_by_invoice_id(12)
    assert sample_result.class == Array
    assert_equal 3, sample_result.length
    assert sample_result.all? {|item| item.class == Transaction}
    assert sample_result.all? {|item| item.invoice_id == 12}
  end

  def test_find_all_by_credit_card_number_returns_array_of_all_objects_with_that_credit_card_number
    assert_equal [], @result.find_all_by_credit_card_number("4084466070522807")
    sample_result = @result.find_all_by_credit_card_number("4084466070588807")
    assert sample_result.class == Array
    assert_equal 5, sample_result.length
    assert sample_result.all? {|item| item.class == Transaction}
    assert sample_result.all? {|item| item.credit_card_number == "4084466070588807"}
  end

  def test_find_all_by_credit_card_expiration_date_returns_array_of_all_objects_with_that_expiration_date
    assert_equal [], @result.find_all_by_credit_card_expiration_date("01/25")
    sample_result = @result.find_all_by_credit_card_expiration_date("01/16")
    assert sample_result.class == Array
    assert_equal 3, sample_result.length
    assert sample_result.all? {|item| item.class == Transaction}
    assert sample_result.all? {|item| item.credit_card_expiration_date == "01/16"}
  end

  def test_find_all_by_result_returns_array_of_all_objects_with_that_result
    assert_equal [], @result.find_all_by_result("super")
    sample_result = @result.find_all_by_result("failed")
    assert sample_result.class == Array
    assert_equal 7, sample_result.length
    assert sample_result.all? { |item| item.class == Transaction}
    assert sample_result.all? { |item| item.result == "failed"}
  end

  def test_find_all_by_created_at_returns_array_of_all_objects_created_then
    assert_equal [], @result.find_all_by_created_at("2075-04-21 14:53:59 UTC")
    sample_result = @result.find_all_by_created_at("2012-03-27 14:54:10 UTC")
    assert sample_result.class == Array
    assert_equal 19, sample_result.length
    assert sample_result.all? { |item| item.class == Transaction}
    assert sample_result.all? { |item| item.created_at == "2012-03-27 14:54:10 UTC"}
  end

  def test_find_all_by_updated_at_returns_array_of_all_objects_updated_then
    assert_equal [], @result.find_all_by_updated_at("2075-04-21 14:53:59 UTC")
    sample_result = @result.find_all_by_updated_at("2012-03-27 14:54:11 UTC")
    assert sample_result.class == Array
    assert_equal 10, sample_result.length
    assert sample_result.all? { |item| item.class == Transaction}
    assert sample_result.all? { |item| item.updated_at == "2012-03-27 14:54:11 UTC"}
  end
end
