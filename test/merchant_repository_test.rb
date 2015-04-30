gem 'minitest'
require 'minitest/autorun'
require 'minitest/pride'
require 'date'
require './lib/merchant_repository'

class MerchantRepositoryTest < Minitest::Test

  def repo
    hashes = {id: 1, name: "Harry's Haberdasher", created_at: "2015-04-29", updated_at: "2015-04-29"},
             {id: 4, name: "Bob's Books", created_at: "2015-04-28", updated_at: "2015-04-28"},
             {id: 8, name: "Harry's Haberdasher", created_at: "2015-04-29", updated_at: "2015-04-29"}
    test_repo = MerchantRepository.new(hashes, self)
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

  def test_find_a_merchant_by_id
    assert_equal 4, repo.find_by_id(4).id
    assert_equal 1, repo.find_by_id(1).id
  end

  def test_find_a_merchant_by_name
    assert_equal 4, repo.find_by_name("Bob's Books").id
  end

  def test_find_a_merchant_by_created_at
    assert_equal 4, repo.find_by_created_at(Date.parse("Wed, 28 Apr 15")).id
  end

  def test_find_by_updated_at
    assert_equal 4, repo.find_by_updated_at(Date.parse("Wed, 28 Apr 15")).id
  end

  def test_find_all_by_name_returns_array_of_all_objects_with_that_name
    assert_equal 2, repo.find_all_by_name("Harry's Haberdasher").count
  end

  def test_find_all_by_created_at_returns_array_of_all_objects_created_then
    assert_equal 2, repo.find_all_by_created_at(Date.parse("Wed, 29 Apr 15")).count
  end

  def test_find_all_by_updated_at_returns_array_of_all_objects_updated_then
    assert_equal 2, repo.find_all_by_updated_at(Date.parse("Wed, 29 Apr 15")).count
  end
end
