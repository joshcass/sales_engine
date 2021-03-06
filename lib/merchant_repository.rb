require_relative 'merchant'

class MerchantRepository
  attr_reader :merchants, :sales_engine, :id

  def inspect
    "#<#{self.class} #{@merchants.size} rows>"
  end

  def initialize(merchant_hashes, sales_engine)
    @merchants = parse_merchants(merchant_hashes, self)
    @sales_engine = sales_engine
  end

  def build_hash_tables
    @id = merchants.group_by{ |merchant| merchant.id }
  end

  def all
    merchants
  end

  def random
    merchants.sample
  end

  def find_by_id(search_id)
    id[search_id].first
  end

  def find_by_name(search_name)
    merchants.detect { |merchant| merchant.name == search_name }
  end

  def find_by_created_at(search_created)
    merchants.detect { |merchant| merchant.created_at == search_created }
  end

  def find_by_updated_at(search_updated)
    merchants.detect { |merchant| merchant.updated_at == search_updated }
  end

  def find_all_by_name(search_name)
    merchants.select { |merchant| merchant.name == search_name }
  end

  def find_all_by_created_at(search_created)
    merchants.select { |merchant| merchant.created_at == search_created }
  end

  def find_all_by_updated_at(search_updated)
    merchants.select { |merchant| merchant.updated_at == search_updated }
  end

  def find_invoices(search_m_id)
    sales_engine.find_all_invoices_by_merchant_id(search_m_id)
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

  private
  def parse_merchants(merchant_hashes, repo)
    merchant_hashes.map do |attributes_hash|
      Merchant.new(attributes_hash, repo)
    end
  end

  def dates_active
    merchants.map do |merchant|
      find_invoices(merchant.id).map do |invoice|
        invoice.created_at
      end.uniq
    end.flatten
  end

end
