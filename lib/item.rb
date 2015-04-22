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
end
