class Transaction
  attr_reader :transaction, :parent

  def initialize(transaction, parent)
    @transaction = transaction
    @parent = parent
  end

  def id
    transaction[:id]
  end

  def invoice_id
    transaction[:invoice_id]
  end

  def credit_card_number
    transaction[:credit_card_number]
  end

  def credit_card_expiration_date
    transaction[:credit_card_expiration_date]
  end

  def result
    transaction[:result]
  end

  def created_at
    transaction[:created_at]
  end

  def updated_at
    transaction[:updated_at]
  end

  def invoice
    parent.find_invoice(invoice_id)
  end
end
