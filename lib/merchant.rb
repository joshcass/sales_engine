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
    Date.strptime("#{merchant[:created_at]}")
  end

  def updated_at
    Date.strptime("#{merchant[:updated_at]}")
  end

  def items
    parent.find_items(id)
  end

  def invoices(date = nil)
    if date
      parent.find_invoices(id).select do |invoice|
        invoice.created_at == date
      end
    else
      parent.find_invoices(id)
    end
  end

  def successful_invoices(date = nil)
    invoices(date).reject do |invoice|
      invoice.failed?
    end
  end

  def pending_invoices
    invoices.select { |invoice| invoice.failed? }
  end

  def successful_invoice_items(date = nil)
    parent.find_invoice_items(successful_invoices(date))
  end

  def revenue(range_of_dates = nil)
    if range_of_dates
      [*range_of_dates].flatten.reduce(0) do |memo, date|
        memo += parent.total_revenue(successful_invoice_items(date))
      end
    else
      parent.total_revenue(successful_invoice_items(nil))
    end
  end

  def number_sold
    parent.total_items_sold(successful_invoice_items)
  end

  def favorite_customer
    successful_invoices.group_by do |invoice|
        invoice.customer
      end.max_by do |customer, quantity|
        quantity.length
      end.first
  end

  def customers_with_pending_invoices
    pending_invoices.map { |invoice| invoice.customer}
  end


end
