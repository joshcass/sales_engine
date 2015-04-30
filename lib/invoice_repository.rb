require_relative 'invoice'

class InvoiceRepository
  attr_reader :invoices,
              :sales_engine,
              :status,
              :id,
              :customer_id,
              :merchant_id,
              :created_at,
              :updated_at

  def inspect
    "#<#{self.class} #{@invoices.size} rows>"
  end

  def initialize(invoice_hashes, sales_engine)
    @invoices = parse_invoices(invoice_hashes, self)
    @sales_engine = sales_engine
  end

  def build_hash_tables
    @id = invoices.group_by{|invoice| invoice.id}
    @customer_id = invoices.group_by{|invoice| invoice.customer_id}
    @merchant_id = invoices.group_by{|invoice| invoice.merchant_id}
    @created_at = invoices.group_by{|invoice| invoice.created_at}
    @updated_at = invoices.group_by{|invoice| invoice.updated_at}
  end

  def build_status_hash_table
    @status = invoices.group_by{|invoice| invoice.all_failed?}
  end

  def all
    invoices
  end

  def random
    invoices.sample
  end

  def find_by_id(search_id)
    id[search_id].first
  end

  def find_by_customer_id(search_id)
    customer_id[search_id].first
  end

  def find_by_merchant_id(search_id)
    merchant_id[search_id].first
  end

  def find_by_status(status)
    invoices.detect { |invoice| invoice.status == status }
  end

  def find_by_created_at(created)
    created_at[created].first
  end

  def find_by_updated_at(updated)
    updated_at[updated].first
  end

  def find_all_by_customer_id(search_id)
    customer_id[search_id]
  end

  def find_all_by_merchant_id(search_id)
    merchant_id[search_id]
  end

  def find_all_by_status(status)
    invoices.select { |invoice| invoice.status == status }
  end

  def find_all_by_created_at(created)
   created_at[created]
  end

  def find_all_by_updated_at(updated)
    updated_at[updated]
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
    new_id = id.max_by { |k, v| k }.first + 1
    invoices << Invoice.new({id: new_id,
        customer_id: invoice_info[:customer].id,
        merchant_id: invoice_info[:merchant].id,
        status: invoice_info[:status],
        created_at: Time.now.to_date,
        updated_at: Time.now.to_date}, self)
    build_hash_tables
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
    status[true]
  end

  def processed(date = nil)
    if date
      status[false].select { |invoice| invoice.created_at == date}
    else
      status[false]
    end
  end

  def processed_invoice_items(date = nil)
    processed(date).flat_map do |invoice|
      find_all_invoice_items(invoice.id)
    end
  end

  def average_revenue(date = nil)
    (sales_engine.find_total_revenue(processed_invoice_items(date)) /
      processed(date).size).round(2)
  end

  def average_items(date = nil)
    (sales_engine.average_item_quantity(processed_invoice_items(date)) /
      processed(date).size).round(2)
  end

  private
  def parse_invoices(invoice_hashes, repo)
    invoice_hashes.map do |atrributes_hash|
      Invoice.new atrributes_hash, repo
    end
  end
end
