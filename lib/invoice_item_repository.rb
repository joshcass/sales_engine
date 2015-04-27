require 'smarter_csv'
require_relative 'invoice_item'
require 'bigdecimal'

class InvoiceItemRepository
  attr_reader :sales_engine, :invoice_items

  def initialize(csv_data, sales_engine)
    @invoice_items = parse_invoice_items(csv_data, self)
    @sales_engine = sales_engine
  end

  def all
    invoice_items
  end

  def random
    invoice_items.sample
  end

  def find_by_id(search_id)
    invoice_items.detect { |item| search_id == item.id }
  end

  def find_all_by_id(search_id)
    invoice_items.select { |item| search_id == item.id }
  end

  def find_by_item_id(search_id)
    invoice_items.detect { |item| search_id == item.item_id }
  end

  def find_all_by_item_id(search_id)
    invoice_items.select { |item| search_id == item.item_id }
  end

  def find_by_invoice_id(search_id)
    invoice_items.detect { |item| search_id == item.invoice_id}
  end

  def find_all_by_invoice_id(search_id)
    invoice_items.select { |item| search_id == item.invoice_id }
  end

  def find_by_quantity(search_quantity)
    invoice_items.detect { |item| search_quantity == item.quantity }
  end

  def find_all_by_quantity(search_quantity)
    invoice_items.select { |item| search_quantity == item.quantity }
  end

  def find_by_unit_price(search_price)
    invoice_items.detect { |item| search_price == item.unit_price }
  end

  def find_all_by_unit_price(search_price)
    invoice_items.select { |item| search_price == item.unit_price }
  end

  def find_by_created_at(search_time)
    invoice_items.detect { |item| search_time == item.created_at}
  end

  def find_all_by_created_at(search_time)
    invoice_items.select { |item| search_time == item.created_at }
  end

  def find_by_updated_at(search_time)
    invoice_items.detect { |item| search_time == item.updated_at}
  end

  def find_all_by_updated_at(search_time)
    invoice_items.select { |item| search_time == item.updated_at }
  end

  def find_invoice(invoice_id)
    sales_engine.find_invoice_by_id(invoice_id)
  end

  def find_item(item_id)
    sales_engine.find_item_by_id(item_id)
  end

  def calculate_total_revenue(invoice_items)
    invoice_items.reduce(0) do |sum, invoice_item|
      sum + (invoice_item.quantity * BigDecimal(".#{invoice_item.unit_price}"))
    end.round(2)
  end

  def calculate_total_quantity(invoice_items)
    invoice_items.reduce(0) { |sum, invoice_item| sum + invoice_item.quantity }
  end

  def group_items_by_quantity(items)
    items.group_by { |item| item }
  end

  def add_invoice_item(invoice_id, item, quantity)
    new_id = invoice_items.max_by { |invoice_item| invoice_item.id }.id + 1
    invoice_items << InvoiceItem.new({id: new_id,
        item_id: item.id,
        invoice_id: invoice_id,
        quantity: quantity,
        unit_price: item.unit_price,
        created_at: Time.now.utc,
        updated_at: Time.now.utc}, self)
  end

  def new_invoice_items(invoice_id, items)
    group_items_by_quantity(items).each do |item, quantity|
      add_invoice_item(invoice_id, item, quantity.length)
    end
  end

  private
  def parse_invoice_items(csv_data, repo)
    csv_data.map { |invoice| InvoiceItem.new(invoice, repo) }
  end
end
