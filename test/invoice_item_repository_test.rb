require 'minitest'
require 'minitest/autorun'
require 'smarter_csv'
require 'bigdecimal'
require_relative '../lib/invoice_item_repository.rb'

class InvoiceItemRepositoryTest < Minitest::Test
  def setup
    @test_invoice_item_repo = InvoiceItemRepository.new(SmarterCSV.process('./test_data/invoice_items.csv'), self)
  end

  def test_all_method_returns_everything
    assert_equal 29, @test_invoice_item_repo.all.count
    assert @test_invoice_item_repo.all.all? { |invoice_item| invoice_item.class == InvoiceItem }
  end

  def test_random_method_returns_random_invoice_item
    assert @test_invoice_item_repo.all.include?(@test_invoice_item_repo.random)
  end

  def test_find_by_id_returns_one_object_with_a_given_id
    assert_equal 1, @test_invoice_item_repo.find_by_id(1).id
    assert_equal 4, @test_invoice_item_repo.find_by_id(4).id
  end

  def test_find_by_item_id_returns_one_object_with_a_given_item_id
    assert_equal 529, @test_invoice_item_repo.find_by_item_id(529).item_id
  end

  def test_find_by_invoice_id_returns_one_object_with_a_given_name
    assert_equal 2, @test_invoice_item_repo.find_by_invoice_id(2).invoice_id
  end

  def test_find_by_created_at_returns_one_object_created_then
    assert_equal 1, @test_invoice_item_repo.find_by_created_at("2012-03-27 14:54:09 UTC").id
  end

  def test_find_by_updated_at_returns_one_object_updated_then
    assert_equal 1, @test_invoice_item_repo.find_by_updated_at("2012-03-27 14:54:09 UTC").id
  end

  def test_find_all_by_id_returns_array_of_all_objects_with_that_id
    assert_equal [], @test_invoice_item_repo.find_all_by_id(135581778)
    sample_result = @test_invoice_item_repo.find_all_by_id(3)
    assert sample_result.class == Array
    assert sample_result.length == 1
    assert sample_result[0].class == InvoiceItem
    assert sample_result[0].id == 3
  end

  def test_find_all_by_item_id_returns_array_of_all_objects_with_that_item_id
    assert_equal [], @test_invoice_item_repo.find_all_by_item_id(12350)
    sample_result = @test_invoice_item_repo.find_all_by_item_id(1921)
    assert sample_result.class == Array
    assert_equal 1, sample_result.length
    assert sample_result.all? { |invoice_item| invoice_item.class == InvoiceItem}
    assert sample_result.all? { |invoice_item| invoice_item.item_id == 1921}
  end

  def test_find_all_by_invoice_id_returns_array_of_all_objects_with_that_invoice_id
    assert_equal [], @test_invoice_item_repo.find_all_by_invoice_id(9989978)
    sample_result = @test_invoice_item_repo.find_all_by_invoice_id(2)
    assert sample_result.class == Array
    assert_equal 4, sample_result.length
    assert sample_result.all? { |invoice_item| invoice_item.class == InvoiceItem}
    assert sample_result.all? { |invoice_item| invoice_item.invoice_id == 2}
  end

  def test_find_all_by_quantity_returns_array_of_all_objects_with_that_quantity
    assert_equal [], @test_invoice_item_repo.find_all_by_quantity(999)
    sample_result = @test_invoice_item_repo.find_all_by_quantity(7)
    assert sample_result.class == Array
    assert_equal 2, sample_result.length
    assert sample_result.all? { |invoice_item| invoice_item.class == InvoiceItem}
    assert sample_result.all? { |invoice_item| invoice_item.quantity == 7}
  end

  def test_find_all_by_unit_price_returns_array_of_all_objects_with_that_price
    assert_equal [], @test_invoice_item_repo.find_all_by_unit_price(BigDecimal("99999.99"))
    sample_result = @test_invoice_item_repo.find_all_by_unit_price(BigDecimal("786.6"))
    assert sample_result.class == Array
    assert_equal 1, sample_result.length
    assert sample_result.all? { |invoice_item| invoice_item.class == InvoiceItem}
    assert sample_result.all? { |invoice_item| invoice_item.unit_price == BigDecimal("786.6")}
  end

  def test_find_all_by_created_at_returns_array_of_all_objects_created_then
    assert_equal [], @test_invoice_item_repo.find_all_by_created_at("2075-04-21 14:53:59 UTC")
    sample_result = @test_invoice_item_repo.find_all_by_created_at("2012-03-27 14:54:09 UTC")
    assert sample_result.class == Array
    assert_equal 15, sample_result.length
    assert sample_result.all? { |invoice_item| invoice_item.class == InvoiceItem}
    assert sample_result.all? { |invoice_item| invoice_item.created_at == "2012-03-27 14:54:09 UTC"}
  end

  def test_find_all_by_updated_at_returns_array_of_all_objects_updated_then
    assert_equal [], @test_invoice_item_repo.find_all_by_updated_at("2075-04-21 14:53:59 UTC")
    sample_result = @test_invoice_item_repo.find_all_by_updated_at("2012-03-27 14:54:09 UTC")
    assert sample_result.class == Array
    assert_equal 15, sample_result.length
    assert sample_result.all? { |invoice_item| invoice_item.class == InvoiceItem}
    assert sample_result.all? { |invoice_item| invoice_item.created_at == "2012-03-27 14:54:09 UTC"}
  end

  def test_find_total_revenue_for_invoice_items_gives_revenue
    invoice_item = @test_invoice_item_repo.find_all_by_invoice_id(28)
    assert_equal BigDecimal("10423.01"), @test_invoice_item_repo.calculate_total_revenue(invoice_item)
  end
end
