require 'smarter_csv'
require_relative 'invoice'

class InvoiceRepository
  attr_reader :invoices

  def initialize(file)
    @invoices = parse_invoices(SmarterCSV.process(file))
  end

  def all
    invoices
  end

  def random
    invoices.sample
  end

  def find_by_id(id)
    invoices.detect do |invoice|
      invoice.id == id
    end
  end

  def find_by_customer_id(customer_id)
    invoices.detect do |invoice|
      invoice.customer_id == customer_id
    end
  end

  def find_by_merchant_id(merchant_id)
    invoices.detect do |invoice|
      invoice.merchant_id == merchant_id
    end
  end

  def find_by_created_at(created)
    invoices.detect do |invoice|
      invoice.created_at == created
    end
  end

  def find_by_updated_at(updated)
    invoices.detect do |invoice|
      invoice.updated_at == updated
    end
  end

  def find_all_by_id(id)
    invoices.select do |invoice|
      invoice.id == id
    end
  end

  def find_all_by_customer_id(customer_id)
    invoices.select do |invoice|
      invoice.customer_id == customer_id
    end
  end

  def find_all_by_merchant_id(merchant_id)
    invoices.select do |invoice|
      invoice.merchant_id == merchant_id
    end
  end

  def find_all_by_created_at(created)
    invoices.select do |invoice|
      invoice.created_at == created
    end
  end

  def find_all_by_updated_at(updated)
    invoices.select do |invoice|
      invoice.updated_at == updated
    end
  end

  private
  def parse_invoices(csv_data)
    csv_data.map do |invoice|
      Invoice.new(invoice)
    end
  end
end
