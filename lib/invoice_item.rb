class InvoiceItem
  attr_reader :invoice_item, :parent

  def initialize(invoice_item, parent)
    @invoice_item = invoice_item
    @parent = parent
  end

  def id
    invoice_item[:id]
  end

  def item_id
    invoice_item[:item_id]
  end

  def invoice_id
    invoice_item[:invoice_id]
  end

  def quantity
    invoice_item[:quantity]
  end

  def unit_price
    BigDecimal(invoice_item[:unit_price]) / 100
  end

  def created_at
    Date.strptime("#{invoice_item[:created_at]}")
  end

  def updated_at
    Date.strptime("#{invoice_item[:updated_at]}")
  end

  def invoice
    parent.find_invoice(invoice_id)
  end

  def failed?
    invoice.failed?
  end

  def item
    parent.find_item(item_id)
  end
end
