require_relative 'customer_repository'
require_relative 'invoice_item_repository'
require_relative 'item_repository'
require_relative 'merchant_repository'
require_relative 'transaction_repository'
require_relative 'invoice_repository'
require_relative 'business_intelligence'
include BusinessIntelligence

class SalesEngine
  attr_reader :directory,
              :customer_repository,
              :invoice_item_repository,
              :item_repository,
              :merchant_repository,
              :transaction_repository,
              :invoice_repository

  def initialize(directory)
    @directory = directory
  end

  def startup
    @customer_repository     = CustomerRepository
                                 .new(parser('customers.csv'), self)
    @invoice_item_repository = InvoiceItemRepository
                                 .new(parser('invoice_items.csv'), self)
    @item_repository         = ItemRepository
                                 .new(parser('items.csv'), self)
    @merchant_repository     = MerchantRepository
                                 .new(parser('merchants.csv'), self)
    @transaction_repository  = TransactionRepository
                                 .new(parser('transactions.csv'), self)
    @invoice_repository      = InvoiceRepository
                                 .new(parser('invoices.csv'), self)
  end

  def find_invoices_by_customer_id(item_id)
    invoice_repository.find_all_by_customer_id(item_id)
  end

  def find_invoice_items_by_item_id(item_id)
    invoice_item_repository.find_all_by_item_id(item_id)
  end

  def find_merchant_by_id(merchant_id)
    merchant_repository.find_by_id(merchant_id)
  end

  def find_invoice_by_id(invoice_id)
    invoice_repository.find_by_id(invoice_id)
  end

  def find_item_by_id(item_id)
    item_repository.find_by_id(item_id)
  end

  def find_customer_by_id(customer_id)
    customer_repository.find_by_id(customer_id)
  end

  def find_all_items_by_merchant_id(merchant_id)
    item_repository.find_all_by_merchant_id(merchant_id)
  end

  def find_all_invoices_by_merchant_id(merchant_id)
    invoice_repository.find_all_by_merchant_id(merchant_id)
  end

  def find_all_transactions_by_invoice_id(invoice_id)
    transaction_repository.find_all_by_invoice_id(invoice_id)
  end

  def find_all_invoice_items_by_invoice_id(invoice_id)
    invoice_item_repository.find_all_by_invoice_id(invoice_id)
  end

  def find_all_items_by_invoice_id(invoice_id)
    find_all_invoice_items_by_invoice_id(invoice_id).map do |invoice_item|
      item_repository.find_by_id(invoice_item.item_id)
    end
  end

  def all_transactions_failed?(invoice_id)
    transaction_repository.transactions_failed?(invoice_id)
  end

  def find_total_revenue(invoice_items)
    invoice_item_repository.calculate_total_revenue(invoice_items)
  end

  def find_total_quantity(invoice_items)
    invoice_item_repository.calculate_total_quantity(invoice_items)
  end

  def add_new_customer(customer)
    customer_repository.new_customer(customer)
  end

  def add_new_merchant(merchant)
    merchant_repository.new_merchant(merchant)
  end

  def add_new_items(items)
    item_repository.new_items(items)
  end

  def add_new_invoice_items(invoice_id, items)
    invoice_item_repository.new_invoice_items(invoice_id, items)
  end

  def add_new_transaction(invoice_id, cc_info)
    transaction_repository.new_transaction(invoice_id, cc_info)
  end

  private
  def parser(filename)
    SmarterCSV.process("#{directory}/#{filename}")
  end
end
