gem 'minitest'
require 'minitest/autorun'
require 'minitest/pride'
require 'date'
require './lib/transaction_repository'

class TransactionRepositoryTest < Minitest::Test

  def repo
    hashes = {id: 1, invoice_id: 3, credit_card_number: "4923661117104166", credit_card_expiration_date: "11/17", result: "success", created_at: "2015-04-29", updated_at: "2015-04-29"},
             {id: 4, invoice_id: 9, credit_card_number: "4738848761455352", credit_card_expiration_date: "04/20", result: "failed", created_at: "2015-04-28", updated_at: "2015-04-28"},
             {id: 8, invoice_id: 3, credit_card_number: "4923661117104166", credit_card_expiration_date: "11/17", result: "success", created_at: "2015-04-29", updated_at: "2015-04-29"}
    test_repo = TransactionRepository.new(hashes, self)
    test_repo.build_hash_tables
    test_repo
  end

  def test_all_returns_all_instances
    assert_equal 3, repo.all.count
  end

  def test_random_returns_a_random_transaction
    sample = repo.random
    assert repo.all.any?{|item| item.id == sample.id}
  end

  def test_find_a_sample_result_by_id
    assert_equal 1, repo.find_by_id(1).id
    assert_equal 4, repo.find_by_id(4).id
  end

  def test_find_a_sample_result_by_invoice_id
    assert_equal 4, repo.find_by_invoice_id(9).id
  end

  def test_find_an_sample_result_by_credit_card_number
    assert_equal 4, repo.find_by_credit_card_number("4738848761455352").id
  end

  def test_find_a_sample_result_by_credit_card_expiration_date
    assert_equal 4, repo.find_by_credit_card_expiration_date("04/20").id
  end

  def test_find_a_sample_result_by_result
    assert_equal 4, repo.find_by_result("failed").id
  end

  def test_find_a_sample_result_by_created_at
    assert_equal 4, repo.find_by_created_at(Date.parse("Wed, 28 Apr 15")).id
  end

  def test_find_a_sampe_result_by_updated_at
    assert_equal 4, repo.find_by_updated_at(Date.parse("Wed, 28 Apr 15")).id
  end

  def test_find_all_by_invoice_id_returns_array_of_all_objects_with_that_invoice_id
    assert_equal 2, repo.find_all_by_invoice_id(3).count
  end

  def test_find_all_by_credit_card_number_returns_array_of_all_objects_with_that_credit_card_number
    assert_equal 2, repo.find_all_by_credit_card_number("4923661117104166").count
  end

  def test_find_all_by_credit_card_expiration_date_returns_array_of_all_objects_with_that_expiration_date
    assert_equal 2, repo.find_all_by_credit_card_expiration_date("11/17").count
  end

  def test_find_all_by_result_returns_array_of_all_objects_with_that_result
    assert_equal 2, repo.find_all_by_result("success").count
  end

  def test_find_all_by_created_at_returns_array_of_all_objects_created_then
    assert_equal 2, repo.find_all_by_created_at(Date.parse("Wed, 29 Apr 15")).count
  end

  def test_find_all_by_updated_at_returns_array_of_all_objects_updated_then
    assert_equal 2, repo.find_all_by_updated_at(Date.parse("Wed, 29 Apr 15")).count
  end
end
