require_relative 'invoice'

class InvoiceRepository
  attr_reader :invoices, :sales_engine, :successful, :failed, :id

  def inspect
    "#<#{self.class} #{@invoices.size} rows>"
  end

  def initialize(invoice_hashes, sales_engine)
    @invoices = parse_invoices(invoice_hashes, self)
    @sales_engine = sales_engine
    groups
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
    invoices.detect { |invoice| invoice.created_at == created}
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
    invoices.select do |invoice|
      Date.strptime("#{invoice.created_at}", '%F') == created
    end
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

  def find_all_items(invoice_id)
    sales_engine.find_all_items_by_invoice_id(invoice_id)
  end

  def find_customer(customer_id)
    sales_engine.find_customer_by_id(customer_id)
  end

  def find_merchant(merchant_id)
    sales_engine.find_merchant_by_id(merchant_id)
  end

  def new_invoice(invoice_info)
    new_id = invoices.max_by { |invoice| invoice.id }.id + 1
    invoices << Invoice.new({id: new_id,
        customer_id: invoice_info[:customer].id,
        merchant_id: invoice_info[:merchant].id,
        status: invoice_info[:status],
        created_at: "#{Time.now.utc}",
        updated_at: "#{Time.now.utc}"}, self)
    find_by_id(new_id)
  end

  def create(invoice_info)
    invoice = new_invoice(invoice_info)
    sales_engine.add_new_invoice_items(invoice.id, invoice_info[:items])
    invoice
  end

  def add_transaction(invoice_id, cc_info)
    sales_engine.add_new_transaction(invoice_id, cc_info)
  end

  def pending
    invoices.select { |invoice| invoice.all_failed? }
  end

  def successful(date = nil)
    if date
      find_all_by_created_at(date).reject { |invoice| invoice.all_failed? }
    else
      invoices.reject { |invoice| invoice.all_failed?}
    end
  end

  def successful_invoice_items(date = nil)
    successful(date).map do |invoice|
      find_all_invoice_items(invoice.id)
    end.flatten
  end

  def average_revenue(date = nil)
    (sales_engine.find_total_revenue(successful_invoice_items(date)) /
      successful(date).size).round(2)
  end

  def average_items(date = nil)
    (sales_engine.average_item_quantity(successful_invoice_items(date)) /
      successful(date).size).round(2)
  end

  private
  def parse_invoices(invoice_hashes, repo)
    invoice_hashes.map do |attributes_hash|
      Invoice.new attributes_hash, repo
    end
  end

  def groups
    @fail = invoices.group_by{|invoice| invoice.all_failed?}
    @success = invoices.group_by{|invoice| !invoice.all_falied?}
    @id = invoices.group_by{|invoice| invoice.id}
  end
end
