require_relative 'invoice_item'
require 'bigdecimal'

class InvoiceItemRepository
  attr_reader :sales_engine,
              :invoice_items,
              :id,
              :item_id,
              :invoice_id,
              :quantity,
              :unit_price,
              :created_at

  def inspect
    "#<#{self.class} #{@invoice_items.size} rows>"
  end

  def initialize(csv_data, sales_engine)
    @invoice_items = parse_invoice_items(csv_data, self)
    @sales_engine = sales_engine
  end

  def build_groups
    @id = invoice_items.group_by{|i_item| i_item.id}
    @item_id = invoice_items.group_by{|i_item| i_item.item_id }
    @invoice_id = invoice_items.group_by{|i_item| i_item.invoice_id}
    @quantity = invoice_items.group_by{|i_item| i_item.quantity}
    @unit_price = invoice_items.group_by{|i_item| i_item.unit_price}
    @created_at = invoice_items.group_by{|i_item| i_item.created_at}
  end

  def all
    invoice_items
  end

  def random
    invoice_items.sample
  end

  def find_by_id(search_id)
    id[search_id].first
  end

  def find_by_item_id(search_id)
    item_id[search_id].first
  end

  def find_all_by_item_id(search_id)
    item_id[search_id]
  end

  def find_by_invoice_id(search_id)
    invoice_id[search_id].first
  end

  def find_all_by_invoice_id(search_id)
    invoice_id[search_id]
  end

  def find_by_quantity(search_quantity)
    quantity[search_quantity].first
  end

  def find_all_by_quantity(search_quantity)
    quantity[search_quantity]
  end

  def find_by_unit_price(search_price)
    unit_price[search_price].first
  end

  def find_all_by_unit_price(search_price)
    unit_price[search_price]
  end

  def find_by_created_at(search_time)
    created_at[search_time].first
  end

  def find_all_by_created_at(search_time)
    created_at[search_time]
  end

  def find_by_updated_at(search_time)
    invoice_items.detect {|invoice_item| invoice_item.updated_at == search_time}
  end

  def find_all_by_updated_at(search_time)
    invoice_items.select {|invoice_item| invoice_item.updated_at == search_time}
  end

  def find_invoice(invoice_id)
    sales_engine.find_invoice_by_id(invoice_id)
  end

  def find_item(item_id)
    sales_engine.find_item_by_id(item_id)
  end

  def calculate_total_revenue(invoice_items)
    invoice_items.reduce(0) do |sum, invoice_item|
      sum + (invoice_item.quantity * invoice_item.unit_price)
    end
  end

  def calculate_total_quantity(invoice_items)
    invoice_items.reduce(0) do |sum, invoice_item|
      sum + invoice_item.quantity
    end
  end

  def calculate_average_item_quantity(invoice_items)
    invoice_items.reduce(0) do |sum, invoice_item|
      sum + BigDecimal(invoice_item.quantity)
    end
  end

  def group_items_by_quantity(items)
    items.group_by { |item| item }
  end

  def add_invoice_item(invoice_id, item, quantity)
    new_id = id.max_by { |k, v| k }.first + 1
    invoice_items << InvoiceItem.new({id: new_id,
        item_id: item.id,
        invoice_id: invoice_id,
        quantity: quantity,
        unit_price: item.unit_price * 100,
        created_at: Time.now.to_date,
        updated_at: Time.now.to_date}, self)
    build_groups
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
