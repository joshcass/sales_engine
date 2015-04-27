module BusinessIntelligence

  def invoice
    parent.find_invoice(invoice_id)
  end

  def invoices(date = nil)
    if date
      parent.find_all_invoices(id).select do |invoice|
        invoice.created_at[0..9] == date
      end
    else
      parent.find_all_invoices(id)
    end
  end

  def transactions
    invoices.map { |invoice| invoice.transactions}.flatten
  end

  def merchants
    invoices.map {|invoice| invoice.merchant}.flatten
  end

  def merchant
    invoice.merchant
  end

  def invoice_items
    invoices.map { |invoice| invoice.invoice_items }.flatten
  end

  def customer
    invoice.customer
  end

  def successful_invoices(date = nil)
    invoices(date).reject { |invoice| invoice.all_failed? }
  end

  def pending_invoices
    invoices.select { |invoice| invoice.all_failed? }
  end

  def successful_invoice_items(date = nil)
    successful_invoices(date).map do |invoice|
      parent.sales_engine.find_all_invoice_items_by_invoice_id(invoice.id)
    end.flatten
  end
end
