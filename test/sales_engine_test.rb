gem 'minitest'
require 'minitest/autorun'
require 'minitest/pride'
require './lib/sales_engine'

class SalesEngineTest < Minitest::Test
  attr_reader :engine

  def setup
    dir = File.expand_path('../test_data', __dir__)
    @engine = SalesEngine.new(dir)
    @engine.startup
  end

  def test_invoice_transactions_method_returns_all_transactions_for_invoice_id
    invoice1 = engine.invoice_repository.find_by_id(1)
    invoice2 = engine.invoice_repository.find_by_id(4)
    assert_equal 2, invoice1.transactions.count
    assert_equal 1, invoice2.transactions.count
  end


  def test_merchant_items_method_returns_all_items_for_merchant_id
    merchant = engine.merchant_repository.find_by_id(23)
    assert_equal 2, merchant.items.count
  end

  def test_merchant_ivoices_method_returns_all_invoices_for_merchant_id
    merchant = engine.merchant_repository.find_by_id(23)
    assert_equal 2, merchant.invoices.count
  end


  def test_invoice_invoice_items_method_returns_all_invoice_items_for_invoice_id
    invoice = engine.invoice_repository.find_by_id(1)
    assert_equal 2, invoice.invoice_items.count
  end

  def test_invoice_items_method_returns_all_items_for_invoice_id
    invoice = engine.invoice_repository.find_by_id(1)
    assert_equal 2, invoice.items.count
  end

  def test_invoice_customer_method_returns_customer_for_that_invoice
    invoice = engine.invoice_repository.find_by_id(4)
    assert_equal 5, invoice.customer.id
  end

  def test_invoice_merhcant_method_returns_merchant_for_that_invoice
    invoice = engine.invoice_repository.find_by_id(4)
    assert_equal 116, invoice.merchant.id
  end

  def test_transaction_invoice_method_returns_invoice_for_that_transaction
    transaction = engine.transaction_repository.find_by_id(1)
    assert_equal 1, transaction.invoice.id
  end

  def test_invoice_item_invoice_method_returns_invoice_for_that_invoice_item
    invoice_item = engine.invoice_item_repository.find_by_id(4)
    assert_equal 4, invoice_item.invoice.id
  end

  def test_invoice_item_item_method_returns_item_for_that_invoice_item
    invoice_item = engine.invoice_item_repository.find_by_id(4)
    assert_equal 5, invoice_item.item.id
  end

  def test_item_invoice_items_method_returns_invoice_items_for_that_item
    item = engine.item_repository.find_by_id(11)
    assert_equal 2, item.invoice_items.count
  end

  def test_item_merchant_method_returns_merchant_that_sells_that_item
    item = engine.item_repository.find_by_id(11)
    assert_equal 23, item.merchant.id
  end

  def test_customer_invoices_method_returns_that_customers_invoices
    customer = engine.customer_repository.find_by_id(11)
    assert_equal 2, customer.invoices.count
  end

  def test_merchant_revenue_method_returns_total_revenue_for_that_merchant
    merchant = engine.merchant_repository.find_by_id(23)
    assert_equal BigDecimal("8999.94"), merchant.revenue
  end

  def test_item_best_day_returns_a_date
    item = engine.item_repository.find_by_id(11)
    assert_equal Date.parse("2015-04-29"), item.best_day
  end

  def test_customer_transactions_method_returns_an_array_of_transactions
    customer = engine.customer_repository.find_by_id(11)
    assert_equal 2, customer.transactions.count
  end

  def test_item_repo_most_revenue_returns_arrays_of_items
    assert_equal 1, engine.item_repository.most_revenue.count
  end

  def test_item_repo_most_quantity_returns_arrays_of_items
    assert_equal 1, engine.item_repository.most_items.count
  end

  def test_find_all_items_sold_by_merchant_returns_all_items_for_merchant
    merchant = engine.merchant_repository.find_by_id(23)
    assert_equal 6, merchant.number_sold
  end

  def test_merchant_favorite_customer_finds_customer_with_most_successful_transactions
    merchant = engine.merchant_repository.find_by_id(23)
    assert_equal 11, merchant.favorite_customer.id
  end

  def test_merchant_pending_invoices_returns_customers_with_failed_transactions
    merchant = engine.merchant_repository.find_by_id(23)
    assert_equal 1, merchant.pending_invoices.count
  end

  def test_merchant_repository_most_revenue_returns_merchants_with_top_revenue
    top_merchants = engine.merchant_repository.most_revenue(2)
    assert_equal 2, top_merchants.count
  end

  def test_merchant_repository_most_items_returns_merchants_who_sold_most_items
    top_merchants = engine.merchant_repository.most_items(2)
    assert_equal 2, top_merchants.count
  end

  def test_invoice_create_creates_new_invoice
    customer = engine.customer_repository.find_by_id(5)
    merchant = engine.merchant_repository.find_by_id(116)
    item1 = engine.item_repository.find_by_id(11)
    item2 = engine.item_repository.find_by_id(5)
    item3 = engine.item_repository.find_by_id(8)
    invoice = engine.invoice_repository.create(customer: customer,
                                               merchant: merchant,
                                               status: "shipped",
                                               items: [item1, item2, item3, item2, item1, item1])
    assert_equal 9, invoice.id
    assert_equal 5, invoice.customer_id
    assert_equal 116, invoice.merchant_id
    assert_equal "shipped", invoice.status
    assert_equal 4, engine.invoice_repository.all.count
  end

  def test_creating_new_invoice_adds_invoice_items
    customer = engine.customer_repository.find_by_id(5)
    merchant = engine.merchant_repository.find_by_id(116)
    item1 = engine.item_repository.find_by_id(11)
    item2 = engine.item_repository.find_by_id(5)
    item3 = engine.item_repository.find_by_id(8)
    engine.invoice_repository.create(customer: customer,
                                     merchant: merchant,
                                     status: "shipped",
                                     items: [item1, item2, item3, item2, item1, item1])
    invoiceitem1 = engine.invoice_item_repository.find_by_id(9)
    invoiceitem2 = engine.invoice_item_repository.find_by_id(10)
    invoiceitem3 = engine.invoice_item_repository.find_by_id(11)
    assert_equal 6, engine.invoice_item_repository.all.count
    assert_equal 3, invoiceitem1.quantity
    assert_equal 2, invoiceitem2.quantity
    assert_equal 1, invoiceitem3.quantity
  end

  def test_charging_invoice_creates_transaction
    customer = engine.customer_repository.find_by_id(5)
    merchant = engine.merchant_repository.find_by_id(116)
    item1 = engine.item_repository.find_by_id(11)
    item2 = engine.item_repository.find_by_id(5)
    item3 = engine.item_repository.find_by_id(8)
    invoice = engine.invoice_repository.create(customer: customer,
      merchant: merchant,
      status: "shipped",
      items: [item1, item2, item3, item2, item1, item1])
    invoice.charge(credit_card_number: "4444333322221111",
                   credit_card_expiration: "10/13",
                   result: "success")
    assert_equal 4, engine.transaction_repository.all.count
  end

  def test_invoice_repo_pending_returns_pending_invoices
    assert_equal 2, engine.invoice_repository.pending.count
  end

  def test_invoice_repo_average_revenue_returns_average
    assert_equal BigDecimal("8999.94"), engine.invoice_repository.average_revenue
  end

  def test_average_revenue_date_restricts_to_date
    assert_equal BigDecimal("8999.94"), engine.invoice_repository.average_revenue(Date.parse("2015-04-29"))
  end

  def test_average_items_returns_average_items_for_invoices
    assert_equal BigDecimal("6.0"), engine.invoice_repository.average_items
  end

  def test_average_items_date_restricts_to_date
    assert_equal BigDecimal("6.0"), engine.invoice_repository.average_items(Date.parse("2015-04-29"))
  end

  def test_customer_most_items_returns_customer_with_most_items_purchased
    assert_equal 11, engine.customer_repository.most_items.id
  end

  def test_customer_most_revenue_returns_customer_who_spent_the_most
    assert_equal 11, engine.customer_repository.most_revenue.id
  end

  def test_customer_days_since_activity_returns_count_of_days_since_last_transaction
    customer = engine.customer_repository.find_by_id(5)
    assert_equal 2, customer.days_since_activity
  end

  def test_customer_pending_invoices_returns_invoices_with_no_successful_transaction
    customer = engine.customer_repository.find_by_id(11)
    assert_equal 1, customer.pending_invoices.count
  end
end
