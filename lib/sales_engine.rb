require_relative 'customer_repository'
require_relative 'invoice_item_repository'
require_relative 'item_repository'
require_relative 'merchant_repository'
require_relative 'transaction_repository'
require_relative 'invoice_repository'

class SalesEngine
  attr_reader :directory, :customer_repository, :invoice_item_repository, :item_repository, :merchant_repository, :transaction_repository, :invoice_repository

  def initialize(directory)
    @directory = directory
  end

  def startup
    @customer_repository = CustomerRepository.new(SmarterCSV.process('directory/customers.csv'), self)
    @invoice_item_repository = InvoiceItemRepository.new(SmarterCSV.process('directory/invoice_items.csv'), self)
    @item_repository = ItemRepository.new(SmarterCSV.process('directory/items.csv'), self)
    @merchant_repository = MerchantRepository.new(SmarterCSV.process('directory/merchants.csv'), self)
    @transaction_repository = TransactionRepository.new(SmarterCSV.process('directory/transactions.csv'), self)
    @invoice_repository = InvoiceRepository.new(SmarterCSV.process('directory/invoices.csv'), self)
  end

  def find_invoices_with_customer_id(id)
    @invoice_repository.find_all_with_customer_id(id)
  end

  def find_invoice_items_by_item_id(id)
    @invoice_item_repository.find_all_by_item_id(id)
  end

  def find_merchant_by_id(id)
    @merchant_repository.find_by_id(id)
  end

  def find_invoice_by_id(id)
    @invoice_repository.find_by_id(id)
  end

  def find_item_by_id(id)
    @item_repository.find_by_id(id)
  end
end
