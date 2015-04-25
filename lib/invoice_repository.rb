require 'smarter_csv'
require_relative 'invoice'

class InvoiceRepository
  attr_reader :invoices, :sales_engine

  def initialize(csv_data, sales_engine)
    @invoices = parse_invoices(csv_data, self)
    @sales_engine = sales_engine
  end

  def all
    invoices
  end

  def random
    invoices.sample
  end

  def find_by_id(id)
    invoices.detect { |invoice| invoice.id == id }
  end

  def find_by_customer_id(customer_id)
    invoices.detect { |invoice| invoice.customer_id == customer_id }
  end

  def find_by_merchant_id(merchant_id)
    invoices.detect { |invoice| invoice.merchant_id == merchant_id }
  end

  def find_by_status(status)
    invoices.detect { |invoice| invoice.status == status }
  end

  def find_by_created_at(created)
    invoices.detect { |invoice| invoice.created_at == created }
  end

  def find_by_updated_at(updated)
    invoices.detect { |invoice| invoice.updated_at == updated }
  end

  def find_all_by_id(id)
    invoices.select { |invoice| invoice.id == id }
  end

  def find_all_by_customer_id(customer_id)
    invoices.select { |invoice| invoice.customer_id == customer_id }
  end

  def find_all_by_merchant_id(merchant_id)
    invoices.select { |invoice| invoice.merchant_id == merchant_id }
  end

  def find_all_by_status(status)
    invoices.select { |invoice| invoice.status == status }
  end

  def find_all_by_created_at(created)
    invoices.select { |invoice| invoice.created_at == created }
  end

  def find_all_by_updated_at(updated)
    invoices.select { |invoice| invoice.updated_at == updated }
  end

  def find_all_transactions(invoice_id)
    sales_engine.find_all_transactions_by_invoice_id(invoice_id)
  end

  def find_all_invoice_items(invoice_id)
    sales_engine.find_all_invoice_items_by_invoice_id(invoice_id)
  end

  def all_transactions_successful?(invoice_id)
    sales_engine.all_transactions_successful?(invoice_id)
  end

  def find_all_items(invoice_id)
    sales_engine.find_all_items_by_invoice_id(invoice_id)
  end

  def find_customer(customer_id)
    sales_engine.find_customer_by_id(customer_id)
  end

  def find_merchant(merchant_id)
    sales_engine.find_merchant_by_id(merchant_id)
  end

  def new_invoice(data_hash)
    new_id = invoices.max_by { |invoice| invoice.id }.id + 1
    invoices << Invoice.new({id: new_id,
                             customer_id: data_hash[:customer].id,
                             merchant_id: data_hash[:merchant].id,
                             status: data_hash[:status],
                             created_at: "#{Time.now.utc}",
                             updated_at: "#{Time.now.utc}"}, self)
    find_by_id(new_id)
  end

  def create(data_hash)
    sales_engine.add_new_customer(data_hash[:customer])
    sales_engine.add_new_merchant(data_hash[:merchant])
    sales_engine.add_new_items(data_hash[:items])
    invoice = new_invoice(data_hash)
    sales_engine.add_new_invoice_items(invoice.id, data_hash[:items])
    invoice
  end

  private
  def parse_invoices(csv_data, repo)
    csv_data.map { |invoice| Invoice.new(invoice, repo) }
  end
end
