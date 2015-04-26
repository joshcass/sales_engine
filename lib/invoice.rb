class Invoice
  attr_reader :invoice, :parent

  def initialize(invoice, parent)
    @invoice = invoice
    @parent = parent
  end

  def id
    invoice[:id]
  end

  def customer_id
    invoice[:customer_id]
  end

  def merchant_id
    invoice[:merchant_id]
  end

  def status
    invoice[:status]
  end

  def created_at
    invoice[:created_at]
  end

  def updated_at
    invoice[:updated_at]
  end

  def transactions
    parent.find_all_transactions(id)
  end

  def all_failed?
    parent.all_transactions_failed?(id)
  end

  def invoice_items
    parent.find_all_invoice_items(id)
  end

  def items
    parent.find_all_items(id)
  end

  def customer
    parent.find_customer(customer_id)
  end

  def merchant
    parent.find_merchant(merchant_id)
  end

  def charge(data_hash)
    parent.add_transaction(id, data_hash)
  end
end
