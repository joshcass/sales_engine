require_relative 'merchant'

class MerchantRepository
  attr_reader :merchants, :sales_engine

  def inspect
    "#<#{self.class} #{@merchants.size} rows>"
  end

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

  def find_invoices(merchant_id)
    sales_engine.find_all_invoices_by_merchant_id(merchant_id)
  end

  def find_items(merchant_id)
    sales_engine.find_all_items_by_merchant_id(merchant_id)
  end

  def find_invoice_items(invoices)
    invoices.flat_map do |invoice|
      sales_engine.find_all_invoice_items_by_invoice_id(invoice.id)
    end
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
    merchants.max_by(top_n) { |merchant| merchant.number_sold }
  end

  def revenue(range_of_dates)
    merchants.reduce(0) {|sum, merchant| sum + merchant.revenue(range_of_dates)}
  end

  def dates_by_revenue(top_n = dates_active.length)
    dates_active.uniq.
    sort_by { |date| revenue(date) }.reverse[0...top_n]
  end

  def dates_active
    merchants.map do |merchant|
      find_invoices(merchant.id).map do |invoice|
        invoice.created_at
      end.uniq
    end.flatten
  end

  private
  def parse_merchants(csv_data, repo)
    csv_data.map { |merchant| Merchant.new(merchant, repo) }
  end
end
