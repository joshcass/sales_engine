gem 'minitest'
require 'minitest/autorun'
require 'minitest/pride'
require './lib/sales_engine'

class SalesEngineTest < Minitest::Test

  def setup
    dir = File.expand_path('../test_data', __dir__)
    @test_engine = SalesEngine.new(dir)
    @test_engine.startup
  end

  def test_merchant_items_method_returns_all_items_for_merchant_id
    merchant = @test_engine.merchant_repository.find_by_id(1)
    assert merchant.items.length == 2
    assert merchant.items.all? { |item| item.is_a?Item }
    assert merchant.items.all? { |item| item.merchant_id == 1 }
  end

  def test_merchant_ivoices_method_returns_all_invoices_for_merchant_id
    merchant = @test_engine.merchant_repository.find_by_id(1)
    assert merchant.invoices.length == 3
    assert merchant.invoices.all? { |invoice| invoice.is_a?Invoice }
    assert merchant.invoices.all? { |invoice| invoice.merchant_id == 1 }
  end

  def test_invoice_transactions_method_returns_all_transactions_for_invoice_id
    invoice = @test_engine.invoice_repository.find_by_id(12)
    assert invoice.transactions.length == 3
    assert invoice.transactions.all? { |transaction| transaction.is_a?Transaction }
    assert invoice.transactions.all? { |transaction| transaction.invoice_id == 12 }
  end

  def test_invoice_invoice_items_method_returns_all_invoice_items_for_invoice_id
    invoice = @test_engine.invoice_repository.find_by_id(1)
    assert invoice.invoice_items.length == 8
    assert invoice.invoice_items.all? { |invoice_item| invoice_item.is_a?InvoiceItem }
    assert invoice.invoice_items.all? { |invoice_item| invoice_item.invoice_id == 1 }
  end

  def test_invoice_items_method_returns_all_items_for_invoice_id
    invoice = @test_engine.invoice_repository.find_by_id(1)
    assert invoice.items.length == 8
    assert invoice.items.all? { |item| item.is_a?Item }
  end

  def test_invoice_customer_method_returns_customer_for_that_invoice
    invoice = @test_engine.invoice_repository.find_by_id(27)
    assert invoice.customer.id == 7
    assert invoice.customer.first_name == "Julius"
  end

  def test_invoice_merhcant_method_returns_merchant_for_that_invoice
    invoice = @test_engine.invoice_repository.find_by_id(16)
    assert invoice.merchant.id == 27
    assert invoice.merchant.name == "Shields, Hirthe and Smith"
  end

  def test_transaction_invoice_method_returns_invoice_for_that_transaction
    transaction = @test_engine.transaction_repository.find_by_id(14)
    assert transaction.invoice.id == 13
    assert transaction.invoice.customer_id == 3
  end

  def test_invoice_item_invoice_method_returns_invoice_for_that_invoice_item
    invoice_item = @test_engine.invoice_item_repository.find_by_id(5)
    assert invoice_item.invoice.id == 1
    assert invoice_item.invoice.merchant_id == 26
  end

  def test_invoice_item_item_method_returns_item_for_that_invoice_item
    invoice_item = @test_engine.invoice_item_repository.find_by_id(11)
    assert invoice_item.item.id == 1849
    assert invoice_item.item.name == "Fairy Halberd"
  end

  def test_item_invoice_items_method_returns_invoice_items_for_that_item
    item = @test_engine.item_repository.find_by_id(541)
    assert item.invoice_items.length == 1
    assert item.invoice_items.all? { |invoice_item| invoice_item.is_a?InvoiceItem }
  end

  def test_item_merchant_method_returns_merchant_that_sells_that_item
    item = @test_engine.item_repository.find_by_id(1920)
    assert item.merchant.id == 27
    assert item.merchant.name == "Shields, Hirthe and Smith"
  end

  def test_customer_invoices_method_returns_that_customers_invoices
    customer = @test_engine.customer_repository.find_by_id(1)
    assert customer.invoices.length == 8
    assert customer.invoices.all? { |invoice| invoice.is_a?Invoice }
    assert customer.invoices.all? { |invoice| invoice.customer_id == 1}
  end

  # def test_merchant_revenue_method_returns_total_revenue_for_that_merchant
  #   merchant = @test_engine.merchant_repository.find_by_id(1)
  #   assert merchant.revenue == BigDecimal("2176571.0")
  # end

  def test_item_best_day_returns_a_date
    item = @test_engine.item_repository.find_by_id(528)
    assert item.best_day.is_a?Date
  end

  def test_customer_transactions_method_returns_an_array_of_transactions
    customer = @test_engine.customer_repository.find_by_id(3)
    assert customer.transactions.is_a?Array
    assert customer.transactions.all? { |entry| entry.is_a?Transaction }
  end

  def test_customer_favorite_merchant_returns_a_merchant
    customer = @test_engine.customer_repository.find_by_id(7)
  end

  def test_item_repo_most_revenue_returns_arrays_of_items
    assert @test_engine.item_repository.most_revenue.all? { |entry| entry.is_a?Item }
    assert @test_engine.item_repository.most_revenue(3).all? { |entry| entry.is_a?Item }
  end

  def test_item_repo_most_quantity_returns_arrays_of_items
    assert @test_engine.item_repository.most_items.all? { |entry| entry.is_a?Item }
    assert @test_engine.item_repository.most_items(3).all? { |entry| entry.is_a?Item }
  end

end
