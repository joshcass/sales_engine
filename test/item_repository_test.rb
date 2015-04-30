require 'minitest'
require 'minitest/autorun'
require 'smarter_csv'
require 'bigdecimal'
require './lib/item_repository'

class ItemRepositoryTest < Minitest::Test

  def repo
    hashes = {id: 1, name: "Centennial Glory", description: "the best item ever", unit_price: 149999, merchant_id: 12, created_at: "2015-04-29", updated_at: "2015-04-29"},
             {id: 4, name: "Book of Alexandria", description: "the worst item ever", unit_price: 199, merchant_id: 5, created_at: "2015-04-28", updated_at: "2015-04-28"},
             {id: 8, name: "Centennial Glory", description: "the best item ever", unit_price: 149999, merchant_id: 12, created_at: "2015-04-29", updated_at: "2015-04-29"}
    test_repo = ItemRepository.new(hashes, self)
    test_repo.build_hash_tables
    test_repo
  end

  def test_all_method_returns_everything
    assert_equal 3, repo.all.count
  end

  def test_random_method_returns_random_item
    sample = repo.random
    assert repo.all.any?{|item| item.id == sample.id}
  end

  def test_find_by_id_returns_one_object_with_a_given_id
    assert_equal "Centennial Glory",   repo.find_by_id(1).name
    assert_equal "Book of Alexandria", repo.find_by_id(4).name
  end

  def test_find_by_name_returns_one_object_with_a_given_name
    assert_equal 1, repo.find_by_name("Centennial Glory").id
    assert_equal 4, repo.find_by_name("Book of Alexandria").id
  end

  def test_find_by_description_returns_one_object_with_a_given_description
    assert_equal 1, repo.find_by_description("the best item ever").id
  end

  def test_find_by_unit_price_returns_one_object_with_that_price
    assert_equal 1, repo.find_by_unit_price(BigDecimal("1499.99")).id
  end

  def test_find_by_merchant_id_returns_one_object_with_that_id
    assert_equal 1, repo.find_by_merchant_id(12).id
  end

  def test_find_by_created_at_returns_one_object_created_then
    assert_equal 1, repo.find_by_created_at(Date.parse("Wed, 29 Apr 15")).id
  end

  def test_find_by_updated_at_returns_one_object_updated_then
    assert_equal 1, repo.find_by_updated_at(Date.parse("Wed, 29 Apr 15")).id
  end

  def test_find_all_by_name_returns_array_of_all_objects_with_that_name
    assert_equal 2, repo.find_all_by_name("Centennial Glory").count
  end

  def test_find_all_by_unit_price_returns_array_of_all_objects_with_that_price
    assert_equal 2, repo.find_all_by_unit_price(BigDecimal("1499.99")).count
  end

  def test_find_all_by_description_returns_array_of_all_objects_with_that_description
    assert_equal 2, repo.find_all_by_description("the best item ever").count
  end

  def test_find_all_by_merchant_id_returns_array_of_all_objects_with_that_merchant_id
    assert_equal 2, repo.find_all_by_merchant_id(12).count
  end

  def test_find_all_by_created_at_returns_array_of_all_objects_created_then
    assert_equal 2, repo.find_all_by_created_at(Date.parse("Wed, 29 Apr 15")).count
  end

  def test_find_all_by_updated_at_returns_array_of_all_objects_updated_then
    assert_equal 2, repo.find_all_by_updated_at(Date.parse("Wed, 29 Apr 15")).count
  end
end
