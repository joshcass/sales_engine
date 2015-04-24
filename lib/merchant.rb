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

  def revenue
    parent.sales_engine.find_total_revenue_for_invoices(invoices)
  end

  def items_sold
    parent.total_items_sold(invoices)
  end

  def favorite_customer
    parent.favorite_customer(invoices)
  end

  def customers_with_pending_invoices
    parent.pending_invoice_customers(invoices)
  end
end
