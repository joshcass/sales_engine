class Merchant
  attr_reader :merchant, :parent

  def initialize(merchant, parent)
    @merchant = merchant
    @parent = parent
  end

  def id
    merchant[:id]
  end

  def name
    merchant[:name]
  end

  def created_at
    merchant[:created_at]
  end

  def updated_at
    merchant[:updated_at]
  end

  def items
    parent.find_all_items(id)
  end

  def invoices
    parent.find_all_invoices(id)
  end

  def successful_invoices
    invoices.select{ |invoice| invoice.all_successful? }
  end

  def failed_invoices
    invoices.reject{ |invoice| invoice.all_successful?}
  end

  def successful_invoice_items
    parent.find_all_successful_invoice_items(successful_invoices)
  end

  def revenue
    parent.find_total_revenue(successful_invoice_items)
  end

  def items_sold
    parent.total_items_sold(successful_invoice_items)
  end

  def favorite_customer
    successful_invoices.group_by do |invoice|
        invoice.customer
      end.max_by do |id, collection|
        collection.length
      end[0]
  end

  def customers_with_pending_invoices
    failed_invoices.map { |invoice| invoice.customer}
  end
end
