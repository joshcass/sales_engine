class InvoiceItem
  attr_reader :data

  def initialize(data)
    @data = data
  end

  def id
    @data[:id]
  end

  def item_id
    @data[:item_id]
  end

  def invoice_id
    @data[:invoice_id]
  end

  def quantity
    @data[:quantity]
  end

  def unit_price
    @data[:unit_price]
  end

  def created_at
    @data[:created_at]
  end

  def updated_at
    @data[:updated_at]
  end
end