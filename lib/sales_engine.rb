require_relative 'customer_repository'
require_relative 'invoice_item_repository'
require_relative 'item_repository'
require_relative 'merchant_repository'
require_relative 'transaction_repository'
require_relative 'invoice_repository'

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
    @customer_repository     = CustomerRepository.new(parse_csv("customers.csv"), self)
    @invoice_item_repository = InvoiceItemRepository.new(parse_csv("invoice_items.csv"), self)
    @item_repository         = ItemRepository.new(parse_csv("items.csv"), self)
    @merchant_repository     = MerchantRepository.new(parse_csv("merchants.csv"), self)
    @transaction_repository  = TransactionRepository.new(parse_csv("transactions.csv"), self)
    @invoice_repository      = InvoiceRepository.new(parse_csv("invoices.csv"), self)
  end

  def find_invoices_with_customer_id(item_id)
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

  def find_customer_by_id(customer_id)
    customer_repository.find_by_id(customer_id)
  end

  def find_total_revenue_for_invoices(invoices)
    successful_invoices = transaction_repository.find_all_successful_invoices(invoices)
    invoice_items = invoice_repository.find_all_invoice_items_for_invoices(successful_invoices)
    invoice_item_repository.total_revenue_for_invoice_items(invoice_items)
  end

  def find_all_items_sold_by_merchant(invoices)
    successful_invoices = transaction_repository.find_all_successful_invoices(invoices)
    invoice_items = invoice_repository.find_all_invoice_items_for_invoices(successful_invoices)
    invoice_item_repository.total_quantity_for_invoice_items(invoice_items)
  end

  def find_merchant_favorite_customer(invoices)
    successful_invoices = transaction_repository.find_all_successful_invoices(invoices)
    find_customer_by_id(successful_invoices.group_by do |invoice|
        invoice.customer_id
      end.max_by do |id, collection|
        collection.length
      end[0])
  end

  def find_customers_with_pending_invoices(invoices)
    successful_invoices = transaction_repository.find_all_failed_invoices(invoices)
    successful_invoices.each {|invoice| invoice.customer}
  end

  private
  def parse_csv(filename)
    SmarterCSV.process("#{directory}/#{filename}")
  end
end
