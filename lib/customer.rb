class Customer
  attr_reader :customer, :parent

  def initialize(customer, parent)
    @customer = customer
    @parent = parent
  end

  def id
    customer[:id]
  end

  def first_name
    customer[:first_name]
  end

  def last_name
    customer[:last_name]
  end

  def created_at
    Date.strptime("#{customer[:created_at]}")
  end

  def updated_at
    Date.strptime("#{customer[:updated_at]}")
  end

  def invoices
    invs = parent.find_invoices(id)
    if invs
      invs
    else
      []
    end

  end

  def transactions
    invoices.flat_map { |invoice| invoice.transactions}
  end

  def merchants
    invoices.flat_map { |invoice| invoice.merchant }
  end

  def successful_invoices
    invoices.reject { |invoice| invoice.failed? }
  end

  def pending_invoices
    invoices.select { |invoice| invoice.all_failed? }
  end

  def successful_invoice_items
    parent.find_invoice_items(successful_invoices)
  end

  def items_purchased
    parent.total_items_purchased(successful_invoice_items)
  end

  def spent
    parent.total_spent(successful_invoice_items)
  end

  def last_transaction
    transactions.max_by do |transaction|
      transaction.created_at
    end
  end

  def days_since_activity
    Time.new.to_date.mjd - last_transaction.created_at.mjd
  end

  def favorite_merchant
    invoices.group_by do |invoice|
        invoice.merchant
      end.max_by do |merchant, quantity|
        quantity.length
      end.first
  end
end
