require 'smarter_csv'
require_relative 'merchant'

class MerchantRepository
  attr_reader :merchants, :sales_engine

  def initialize(csv_data, sales_engine)
    @merchants = parse_merchants(csv_data, self)
    @sales_engine = sales_engine
  end

  def all
    merchants
  end

  def random
    merchants.sample
  end

  def find_by_id(id)
    merchants.detect {|merchant| merchant.id == id}
  end

  def find_by_name(name)
    merchants.detect { |merchant| merchant.name == name }
  end

  def find_by_created_at(created)
    merchants.detect { |merchant| merchant.created_at == created }
  end

  def find_by_updated_at(updated)
    merchants.detect { |merchant| merchant.updated_at == updated }
  end

  def find_all_by_id(id)
    merchants.select { |merchant| merchant.id == id }
  end

  def find_all_by_name(name)
    merchants.select { |merchant| merchant.name == name }
  end

  def find_all_by_created_at(created)
    merchants.select { |merchant| merchant.created_at == created }
  end

  def find_all_by_updated_at(updated)
    merchants.select { |merchant| merchant.updated_at == updated }
  end

  def find_all_invoices(merchant_id)
    sales_engine.find_all_invoices_by_merchant_id(merchant_id)
  end

  def find_all_items(merchant_id)
    sales_engine.find_all_items_by_merchant_id(merchant_id)
  end

  def find_all_invoice_items(invoices)
    invoices.map do |invoice|
      sales_engine.find_all_invoice_items_by_invoice_id(invoice.id)
    end.flatten
  end

  def total_revenue(invoice_items)
    sales_engine.find_total_revenue(invoice_items)
  end

  def total_items_sold(invoice_items)
    sales_engine.find_total_quantity(invoice_items)
  end

  def most_revenue(top_n = 1)
    merchants.max_by(top_n) { |merchant| merchant.revenue }
  end

  def most_items(top_n = 1)
    merchants.max_by(top_n) { |merchant| merchant.items_sold}
  end

  def revenue(date)
    merchants.reduce(0) {|sum, merchant| sum + merchant.revenue(date)}
  end

  def new_merchant(merchant)
    merchants << merchant if merchants.none? do |a_merchant|
      a_merchant == merchant
    end
  end

  private
  def parse_merchants(csv_data, repo)
    csv_data.map { |merchant| Merchant.new(merchant, repo) }
  end
end
