require_relative 'business_intelligence'
include BusinessIntelligence

class Item
  attr_reader :item, :parent

  def initialize(item, parent)
    @item = item
    @parent = parent
  end

  def id
    item[:id]
  end

  def name
    item[:name]
  end

  def description
    item[:description]
  end

  def unit_price
    item[:unit_price]
  end

  def merchant_id
    item[:merchant_id]
  end

  def created_at
    item[:created_at]
  end

  def updated_at
    item[:updated_at]
  end

  def invoice_items
    parent.find_invoice_items(id)
  end

  def merchant
    parent.find_merchant(merchant_id)
  end

  def revenue
    parent.sales_engine.find_total_revenue(successful_invoice_items_for_item)
  end

  def successful_invoice_items_for_item
    successful_invoice_items & invoice_items
  end

  def items_sold
    parent.sales_engine.find_total_quantity(successful_invoice_items_for_item)
  end

  def best_day
    Date.strptime(invoice_items.
        group_by { |invoice_item| created_at }
                    .max_by{|time, collection| collection
                                                 .length}[0], '%F')
  end
end
