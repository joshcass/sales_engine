gem 'minitest'
require 'minitest/autorun'
require 'minitest/pride'
require 'smarter_csv'
require './lib/invoice_repository'

class InvoiceRepositoryTest < Minitest::Test

  def repo
    hashes = {id: 1, customer_id: 11, merchant_id: 23, status: "shipped", created_at: "2015-04-29", updated_at: "2015-04-29"},
             {id: 4, customer_id: 5, merchant_id: 116, status: "not shipped", created_at: "2015-04-28", updated_at: "2015-04-28"},
             {id: 8, customer_id: 11, merchant_id: 23, status: "shipped", created_at: "2015-04-29", updated_at: "2015-04-29"}
    test_repo = InvoiceRepository.new(hashes, self)
    test_repo.build_hash_tables
    test_repo
  end

  def test_all_returns_all_instances
    assert_equal 3, repo.all.count
  end

  def test_random_returns_a_random_sample_from_the_repository
    sample = repo.random
    assert repo.all.any?{|item| item.id == sample.id}
  end

  def test_find_a_sample_result_by_id
    assert_equal 1, repo.find_by_id(1).id
    assert_equal 4, repo.find_by_id(4).id
  end

  def test_find_a_sample_result_by_customer_id
    assert_equal 1, repo.find_by_customer_id(11).id
    assert_equal 4, repo.find_by_customer_id(5).id
  end

  def test_find_an_sample_result_by_merchant_id
    assert_equal 1, repo.find_by_merchant_id(23).id
    assert_equal 4, repo.find_by_merchant_id(116).id
  end

  def test_find_a_sample_result_by_status
    assert_equal 4, repo.find_by_status("not shipped").id
  end

  def test_find_a_sample_result_by_created_at
    assert_equal 4, repo.find_by_created_at(Date.parse("Wed, 28 Apr 15")).id
  end

  def test_find_a_sampe_result_by_updated_at
    assert_equal 4, repo.find_by_updated_at(Date.parse("Wed, 28 Apr 15")).id
  end

  def test_find_all_by_customer_id_returns_array_of_all_objects_with_that_customer_id
    assert_equal 2, repo.find_all_by_customer_id(11).count
  end

  def test_find_all_by_merchant_id_returns_array_of_all_objects_with_that_merchant_id
    assert_equal 2, repo.find_all_by_merchant_id(23).count
  end

  def test_find_all_by_status_returns_array_of_all_objects_with_that_status
    assert_equal 2, repo.find_all_by_status("shipped").count
  end

  def test_find_all_by_created_at_returns_array_of_all_objects_created_then
    assert_equal 2, repo.find_all_by_created_at(Date.parse("Wed, 29 Apr 15")).count
  end

  def test_find_all_by_updated_at_returns_array_of_all_objects_updated_then
    assert_equal 2, repo.find_all_by_updated_at(Date.parse("Wed, 29 Apr 15")).count
  end
end
