require 'smarter_csv'
require 'bigdecimal'
require_relative 'invoice_item'

class InvoiceItemRepository
  attr_reader :sales_engine

  def initialize(csv_data, sales_engine)
    @invoice_items = csv_data.map do |item|
      InvoiceItem.new(item, self)
    end
    @sales_engine = sales_engine
  end

  def all
    @invoice_items
  end

  def random
    @invoice_items.sample
  end

  def find_by_id(search_id)
    @invoice_items.detect { |item| search_id == item.id }
  end

  def find_all_by_id(search_id)
    @invoice_items.select { |item| search_id == item.id }
  end

  def find_by_item_id(search_id)
    @invoice_items.detect { |item| search_id == item.item_id }
  end

  def find_all_by_item_id(search_id)
    @invoice_items.select { |item| search_id == item.item_id }
  end

  def find_by_invoice_id(search_id)
    @invoice_items.detect { |item| search_id == item.invoice_id}
  end

  def find_all_by_invoice_id(search_id)
    @invoice_items.select { |item| search_id == item.invoice_id }
  end

  def find_by_quantity(search_quantity)
    @invoice_items.detect { |item| search_quantity == item.quantity }
  end

  def find_all_by_quantity(search_quantity)
    @invoice_items.select { |item| search_quantity == item.quantity }
  end

  def find_by_unit_price(search_price)
    @invoice_items.detect { |item| search_price == item.unit_price }
  end

  def find_all_by_unit_price(search_price)
    @invoice_items.select { |item| search_price == item.unit_price }
  end

  def find_by_created_at(search_time)
    @invoice_items.detect { |item| search_time == item.created_at}
  end

  def find_all_by_created_at(search_time)
    @invoice_items.select { |item| search_time == item.created_at }
  end

  def find_by_updated_at(search_time)
    @invoice_items.detect { |item| search_time == item.updated_at}
  end

  def find_all_by_updated_at(search_time)
    @invoice_items.select { |item| search_time == item.updated_at }
  end

  def find_invoice(invoice_id)
    @sales_engine.find_invoice_by_id(invoice_id)
  end

  def find_item(item_id)
    @sales_engine.find_item_by_id(item_id)
  end

  def total_revenue_for_invoice_items(invoice_items)
    invoice_items.reduce(0) { |sum, invoice_item| sum + (BigDecimal(invoice_item.unit_price) * BigDecimal(invoice_item.quantity)) }.round(2)
  end

  def total_quantity_for_invoice_items(invoice_items)
    invoice_items.reduce(0) { |sum, invoice_item| sum + invoice_item.quantity }
  end
end
