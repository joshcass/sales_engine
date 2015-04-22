class Invoice
  attr_reader :invoice

  def initialize(invoice)
    @invoice = invoice
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
end