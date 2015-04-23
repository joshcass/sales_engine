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

  def most_revenue(X)
    # merchant.total_revenue method in Merchant class calls out to sales_engine via merchant_repo passing merchant id
    # SALES_ENGINE
    # looks up all invoices for merchant => method already exists
    # once we have invoices we look up the invoice items => method already exists
    # multiply quantity by price to get total for each invoice
    # add up all the totals for that merchant
    # return total_revenue to caller

    # most_revenue method sorts all merchants by merchant.total_revenue
    # take top X merchants
  end

  def most_items(X)
    # merchant.total_items_sold method in Merchant class calls out sales_engine via merchant_repo passing merchant id
    # SALES_ENGINE
    # looks up all invoices for merchant => method already exists
    # once it has invoices it looks up invoice items => method already exists
    # takes quantity of items for each invoice
    # adds up total quantity for the merchant
    # return total_items_sold to caller

    # most items method sorts all merchants by merchant.total_items_sold
    # take top X merchants
  end

  def revenue(date)
    # does stuff



  end
  private
  def parse_merchants(csv_data, repo)
    csv_data.map { |merchant| Merchant.new(merchant, repo) }
  end

end
