require_relative 'item'

class ItemRepository
  attr_reader :sales_engine,
              :items,
              :id,
              :unit_price,
              :merchant_id

  def inspect
    "#<#{self.class} #{@items.size} rows>"
  end

  def initialize(item_hashes, sales_engine)
    @items = parse_items(item_hashes, self)
    @sales_engine = sales_engine
  end

  def build_groups
    @id = items.group_by{|item| item.id}
    @unit_price = items.group_by{|item| item.unit_price}
    @merchant_id = items.group_by{|item| item.merchant_id}
  end

  def all
    items
  end

  def random
    items.sample
  end

  def find_by_id(search_id)
    id[search_id].first
  end

  def find_by_name(search_name)
    items.detect { |item| search_name.downcase == item.name.downcase }
  end

  def find_all_by_name(name)
    items.select {|item| item.name == name}
  end

  def find_by_unit_price(search_price)
    unit_price[search_price].first
  end

  def find_all_by_unit_price(search_price)
    unit_price[search_price]
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
    merchant_id[search_m_id].first
  end

  def find_all_by_merchant_id(search_m_id)
    merchant_id[search_m_id]
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

  def find_invoice_items(id)
    sales_engine.find_invoice_items_by_item_id(id)
  end

  def find_merchant(merchant_id)
    sales_engine.find_merchant_by_id(merchant_id)
  end

  def item_revenue(invoice_items)
    sales_engine.find_total_revenue(invoice_items)
  end

  def item_units_sold(invoice_items)
    sales_engine.find_total_quantity(invoice_items)
  end

  def most_revenue(top_n = 1)
    items.max_by(top_n) { |item| item.revenue }
  end

  def most_items(top_n = 1)
    items.max_by(top_n) { |item| item.number_sold }
  end

  private
  def parse_items(item_hashes, repo)
    item_hashes.map { |item_hash| Item.new(item_hash, repo) }
  end
end
