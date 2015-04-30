require 'minitest'
require 'minitest/autorun'
require 'smarter_csv'
require 'bigdecimal'
require_relative '../lib/invoice_item_repository.rb'

class InvoiceItemRepositoryTest < Minitest::Test

  def repo
    hashes = {id: 1, item_id: 11, invoice_id: 23, unit_price: 149999, quantity: 3, created_at: "2015-04-29", updated_at: "2015-04-29"},
             {id: 4, item_id: 5, invoice_id: 116, unit_price: 199, quantity: 7, created_at: "2015-04-28", updated_at: "2015-04-28"},
             {id: 1, item_id: 11, invoice_id: 23, unit_price: 149999, quantity: 3, created_at: "2015-04-29", updated_at: "2015-04-29"}
    test_repo = InvoiceItemRepository.new(hashes, self)
    test_repo.build_hash_tables
    test_repo
  end

  def test_all_method_returns_everything
    assert_equal 3, repo.all.count
  end

  def test_random_method_returns_random_invoice_item
    sample = repo.random
    assert repo.all.any?{|item| item.id == sample.id}
  end

  def test_find_by_id_returns_one_object_with_a_given_id
    assert_equal 1, repo.find_by_id(1).id
    assert_equal 4, repo.find_by_id(4).id
  end

  def test_find_by_item_id_returns_one_object_with_a_given_item_id
    assert_equal 5, repo.find_by_item_id(5).item_id
  end

  def test_find_by_invoice_id_returns_one_object_with_a_given_name
    assert_equal 116, repo.find_by_invoice_id(116).invoice_id
  end

  def test_find_by_created_at_returns_one_object_created_then
    assert_equal 4, repo.find_by_created_at(Date.parse("2015-04-28")).id
  end

  def test_find_by_updated_at_returns_one_object_updated_then
    assert_equal 4, repo.find_by_updated_at(Date.parse("2015-04-28")).id
  end

  def test_find_all_by_item_id_returns_array_of_all_objects_with_that_item_id
    assert_equal 2, repo.find_all_by_item_id(11).count
  end

  def test_find_all_by_invoice_id_returns_array_of_all_objects_with_that_invoice_id
    assert_equal 2, repo.find_all_by_invoice_id(23).count
  end

  def test_find_all_by_quantity_returns_array_of_all_objects_with_that_quantity
    assert_equal 2, repo.find_all_by_quantity(3).count
  end

  def test_find_all_by_unit_price_returns_array_of_all_objects_with_that_price
    assert_equal 2, repo.find_all_by_unit_price(BigDecimal("1499.99")).count
  end

  def test_find_all_by_created_at_returns_array_of_all_objects_created_then
    assert_equal 2, repo.find_all_by_created_at(Date.parse("Wed, 29 Apr 15")).count
  end

  def test_find_all_by_updated_at_returns_array_of_all_objects_updated_then
    assert_equal 2, repo.find_all_by_updated_at(Date.parse("Wed, 29 Apr 15")).count
  end

  def test_find_total_revenue_for_invoice_items_gives_revenue
    invoice_items = repo.find_all_by_invoice_id(23)
    assert_equal BigDecimal("8999.94"), repo.calculate_total_revenue(invoice_items)
  end

  def test_find_total_quantity_for_invoice_items_gives_quantity
    invoice_items = repo.find_all_by_invoice_id(23)
    assert_equal 6, repo.calculate_total_quantity(invoice_items)
  end

  def test_average_item_quanity_gives_average
    invoice_items = repo.find_all_by_invoice_id(23)
    assert_equal BigDecimal("6.0"), repo.calculate_average_item_quantity(invoice_items)
  end
end
