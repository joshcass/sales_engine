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

  def test_invcice_invoice_items_method_returns_all_invoice_items_for_invoice_id
    invoice = @test_engine.invoice_repository.find_by_id(1)
    assert invoice.invoice_items.length == 8
    assert invoice.invoice_items.all? { |invoice_item| invoice_item.is_a?InvoiceItem }
    assert invoice.invoice_items.all? { |invoice_item| invoice_item.invoice_id == 1 }
  end


end
