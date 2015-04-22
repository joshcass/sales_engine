require 'smarter_csv'
require_relative 'invoice_item'

class InvoiceItemRepository
  def initialize(csv_data)
    @invoice_items = csv_data.map do |item|
      InvoiceItem.new(item)
    end
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
end
