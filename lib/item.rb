class Item
  attr_reader :item, :parent

  def initialize(item, parent)
    @item = item
    @parent = parent
  end

  def id
    @item[:id]
  end

  def name
    @item[:name]
  end

  def description
    @item[:description]
  end

  def unit_price
    @item[:unit_price]
  end

  def merchant_id
    @item[:merchant_id]
  end

  def created_at
    @item[:created_at]
  end

  def updated_at
    @item[:updated_at]
  end

  def invoice_items
    @parent.find_invoice_items(id)
  end

  def merchant
    @parent.find_merchant(merchant_id)
  end

  # def best_day
    # find all invoice items by invoice id
    # get all of the invoices group by date
    # return the date with the most invoices
  # end
end
