require 'smarter_csv'
require_relative 'invoice'

class InvoiceRepository
  attr_reader :invoices

  def initialize(csv_data)
    @invoices = parse_invoices(csv_data, self)
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

  private
  def parse_invoices(csv_data, repo)
    csv_data.map { |invoice| Invoice.new(invoice, repo) }
  end

end
