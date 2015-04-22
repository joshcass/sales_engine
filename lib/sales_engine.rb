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
    @customer_repository = CustomerRepository.new(SmarterCSV.process("#{directory}/customers.csv"), self)
    @invoice_item_repository = InvoiceItemRepository.new(SmarterCSV.process("#{directory}/invoice_items.csv"), self)
    @item_repository = ItemRepository.new(SmarterCSV.process("#{directory}/items.csv"), self)
    @merchant_repository = MerchantRepository.new(SmarterCSV.process("#{directory}/merchants.csv"), self)
    @transaction_repository = TransactionRepository.new(SmarterCSV.process("#{directory}/transactions.csv"), self)
    @invoice_repository = InvoiceRepository.new(SmarterCSV.process("#{directory}/invoices.csv"), self)
  end



end
