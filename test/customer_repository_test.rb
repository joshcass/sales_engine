require 'minitest'
require 'minitest/autorun'
require 'smarter_csv'
require_relative '../lib/customer_repository.rb'

class CustomerRepositoryTest < Minitest::Test

  def repo
    hashes = {id: 1, first_name: "Julius", last_name: "Caesar", created_at: "2015-04-29", updated_at: "2015-04-29"},
             {id: 4, first_name: "Afton", last_name: "Hollister", created_at: "2015-04-28", updated_at: "2015-04-28"},
             {id: 8, first_name: "Julius", last_name: "Caesar", created_at: "2015-04-29", updated_at: "2015-04-29"}
    test_repo = CustomerRepository.new(hashes, self)
    test_repo.build_hash_tables
    test_repo
  end

  def test_all_method_returns_everything
    assert_equal 3, repo.all.count
  end

  def test_random_method_returns_random_customer
    sample = repo.random
    assert repo.all.any?{|item| item.id == sample.id}
  end

  def test_find_by_id_returns_one_object_with_a_given_id
    assert_equal "Julius", repo.find_by_id(1).first_name
    assert_equal "Afton", repo.find_by_id(4).first_name
  end

  def test_find_by_first_name_returns_one_object_with_a_given_name
    assert_equal 4, repo.find_by_first_name("Afton").id
  end

  def test_find_by_last_name_returns_one_object_with_a_given_name
    assert_equal 4, repo.find_by_last_name("Hollister").id
  end

  def test_find_by_created_at_returns_one_object_created_then
    assert_equal 4, repo.find_by_created_at(Date.parse("2015-04-28")).id
  end

  def test_find_by_updated_at_returns_one_object_updated_then
    assert_equal 4, repo.find_by_updated_at(Date.parse("2015-04-28")).id
  end

  def test_find_all_by_first_name_returns_array_of_all_objects_with_that_name
    assert_equal 2, repo.find_all_by_first_name("Julius").count
  end

  def test_find_all_by_last_name_returns_array_of_all_objects_with_that_name
    assert_equal 2, repo.find_all_by_last_name("Caesar").count
  end

  def test_find_all_by_created_at_returns_array_of_all_objects_created_then
    assert_equal 2, repo.find_all_by_created_at(Date.parse("2015-04-29")).count
  end

  def test_find_all_by_updated_at_returns_array_of_all_objects_updated_then
    assert_equal 2, repo.find_all_by_updated_at(Date.parse("2015-04-29")).count
  end
end
