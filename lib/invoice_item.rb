class InvoiceItem
  attr_reader :item, :parent

  def initialize(item, parent)
    @item = item
    @parent = parent
  end

  def id
    @item[:id]
  end

  def item_id
    @item[:item_id]
  end

  def invoice_id
    @item[:invoice_id]
  end

  def quantity
    @item[:quantity]
  end

  def unit_price
    @item[:unit_price]
  end

  def created_at
    @item[:created_at]
  end

  def updated_at
    @item[:updated_at]
  end
end
