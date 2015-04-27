require 'smarter_csv'
require_relative 'item'

class ItemRepository
  attr_reader :sales_engine, :items

  def inspect
    "#<#{self.class} #{@merchants.size} rows>"
  end

  def initialize(csv_data, sales_engine)
    @items = parse_items(csv_data, self)
    @sales_engine = sales_engine
  end

  def all
    items
  end

  def random
    items.sample
  end

  def find_by_id(search_id)
    items.detect { |item| search_id == item.id }
  end

  def find_all_by_id(search_id)
    items.select { |item| search_id == item.id }
  end

  def find_by_name(search_name)
    items.detect { |item| search_name.downcase == item.name.downcase}
  end

  def find_all_by_name(search_name)
    items.select { |item| search_name.downcase == item.name.downcase }
  end

  def find_by_unit_price(search_price)
    items.detect { |item| search_price == item.unit_price}
  end

  def find_all_by_unit_price(search_price)
    items.select { |item| search_price == item.unit_price }
  end

  def find_by_description(search_description)
    items.detect do |item|
      search_description.downcase == item.description.downcase
    end
  end

  def find_all_by_description(search_description)
    items.select do |item|
      search_description.downcase == item.description.downcase
    end
  end

  def find_by_merchant_id(search_m_id)
    items.detect { |item| search_m_id == item.merchant_id}
  end

  def find_all_by_merchant_id(search_m_id)
    items.select { |item| search_m_id == item.merchant_id }
  end

  def find_by_created_at(search_time)
    items.detect { |item| search_time == item.created_at}
  end

  def find_all_by_created_at(search_time)
    items.select { |item| search_time == item.created_at }
  end

  def find_by_updated_at(search_time)
    items.detect { |item| search_time == item.updated_at}
  end

  def find_all_by_updated_at(search_time)
    items.select { |item| search_time == item.updated_at }
  end

  def find_all_invoices(id)
    sales_engine.find_invoice_items_by_item_id(id).map do |invoice_item|
      sales_engine.find_invoice_by_id(invoice_item.invoice_id)
    end
  end

  def find_invoice_items(id)
    sales_engine.find_invoice_items_by_item_id(id)
  end

  def find_merchant(merchant_id)
    sales_engine.find_merchant_by_id(merchant_id)
  end

  def new_items(items_to_add)
    items << items_to_add.uniq.reject { |item| items.include?(item) }
  end

  def most_revenue(top_n = 1)
    items.max_by(top_n) { |item| item.revenue }
  end

  def most_items(top_n = 1)
    items.max_by(top_n) { |item| item.items_sold }
  end

  private
  def parse_items(csv_data, repo)
    csv_data.map { |invoice| Item.new(invoice, repo) }
  end
end
