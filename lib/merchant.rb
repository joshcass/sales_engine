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
    parent.find_items(id)
  end

  def invoices(date = nil)
    if date
      @invoices = parent.find_invoices(id).select do |invoice|
        Date.strptime("#{invoice.created_at}", '%F') == date
      end
    else
      @invoices = parent.find_invoices(id)
    end
  end

  def successful_invoices(date = nil)
    @successful_invoices = invoices(date).reject do |invoice|
      invoice.all_failed?
    end
  end

  def pending_invoices
    invoices.select { |invoice| invoice.all_failed? }
  end

  def successful_invoice_items(date = nil)
    @successful_invoice_items = parent
                                  .find_invoice_items(successful_invoices(date))
  end

  def revenue(date = nil)
    parent.total_revenue(successful_invoice_items(date))
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
