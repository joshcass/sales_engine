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
    BigDecimal(item[:unit_price]) / 100
  end

  def merchant_id
    item[:merchant_id]
  end

  def created_at
    Date.strptime("#{item[:created_at]}")
  end

  def updated_at
    Date.strptime("#{item[:updated_at]}")
  end

  def invoice_items
    i_items = parent.find_invoice_items(id)
    if i_items
      i_items
    else
      []
    end
  end

  def merchant
    parent.find_merchant(merchant_id)
  end

  def successful_invoice_items
    invoice_items.reject do |invoice_item|
      invoice_item.failed?
    end
  end

  def revenue
      parent.item_revenue(successful_invoice_items)
  end

  def number_sold
    parent.item_units_sold(successful_invoice_items)
  end

  def grouped_by_date
    successful_invoice_items.group_by do |invoice_item|
      invoice_item.invoice.created_at
    end
  end

  def best_day
    grouped_by_date.max_by do |date, quantity|
        quantity.length
      end.first
  end
end
