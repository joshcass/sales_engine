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

  def find_all_items(merchant_id)
    sales_engine.find_all_items_by_merchant_id(merchant_id)
  end

  def find_all_invoices(merchant_id)
    sales_engine.find_all_invoices_by_merchant_id(merchant_id)
  end

  def find_total_revenue(invoices)
    sales_engine.find_total_revenue_for_invoices(invoices)
  end

  # def most_revenue(X)
    # sorts all merchants by merchant.revenue
    # take top X merchants
  # end

  # def most_items(X)
    # sorts all merchants by merchant.items_sold
    # take top X merchants
  # end

  # def revenue(date)
    # calls merchant.revenue(date) on all merchants
    # totals up revenue
  # end

  private
  def parse_merchants(csv_data, repo)
    csv_data.map { |merchant| Merchant.new(merchant, repo) }
  end
end
