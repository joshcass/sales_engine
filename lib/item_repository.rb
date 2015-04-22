require 'smarter_csv'
require_relative 'item'

class ItemRepository
  attr_reader :sales_engine

  def initialize(csv_data, sales_engine)
    @items = csv_data.map do |item|
      Item.new(item, self)
    end
    @sales_engine = sales_engine
  end

  def all
    @items
  end

  def random
    @items.sample
  end

  def find_by_id(search_id)
    @items.detect { |item| search_id == item.id }
  end

  def find_all_by_id(search_id)
    @items.select { |item| search_id == item.id }
  end

  def find_by_name(search_name)
    @items.detect { |item| search_name.downcase == item.name.downcase}
  end

  def find_all_by_name(search_name)
    @items.select { |item| search_name.downcase == item.name.downcase }
  end

  def find_by_unit_price(search_price)
    @items.detect { |item| search_price == item.unit_price}
  end

  def find_all_by_unit_price(search_price)
    @items.select { |item| search_price == item.unit_price }
  end

  def find_by_description(search_description)
    @items.detect { |item| search_description.downcase == item.description.downcase}
  end

  def find_all_by_description(search_description)
    @items.select { |item| search_description.downcase == item.description.downcase }
  end

  def find_by_merchant_id(search_m_id)
    @items.detect { |item| search_m_id == item.merchant_id}
  end

  def find_all_by_merchant_id(search_m_id)
    @items.select { |item| search_m_id == item.merchant_id }
  end

  def find_by_created_at(search_time)
    @items.detect { |item| search_time == item.created_at}
  end

  def find_all_by_created_at(search_time)
    @items.select { |item| search_time == item.created_at }
  end

  def find_by_updated_at(search_time)
    @items.detect { |item| search_time == item.updated_at}
  end

  def find_all_by_updated_at(search_time)
    @items.select { |item| search_time == item.updated_at }
  end

  def find_invoice_items(id)
    @sales_engine.find_invoice_items_by_item_id(id)
  end

  def find_merchant(merchant_id)
    @sales_engine.find_merchant_by_id(merchant_id)
  end
end
