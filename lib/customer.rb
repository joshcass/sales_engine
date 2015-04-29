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
    customer[:created_at]
  end

  def updated_at
    @customer[:updated_at]
  end

  def invoices
    @parent.find_invoices(id)
  end

  def transactions
    invoices.flat_map { |invoice| invoice.transactions}
  end

  def invoices
    parent.find_invoices(id)
  end

  def transactions
    invoices.map{ |invoice| invoice.transactions}.flatten
  end

  def merchants
    invoices.map {|invoice| invoice.merchant}.flatten
  end

  def successful_invoices
    invoices.reject { |invoice| invoice.all_failed? }
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
      Date.strptime("#{transaction.created_at}", '%F')
    end
  end

  def days_since_activity
    Time.new.to_date.mjd -
      Date.strptime("#{last_transaction.created_at}", '%F').mjd
  end

  def favorite_merchant
    invoices.group_by do |invoice|
        invoice.merchant
      end.max_by do |merchant, quantity|
        quantity.length
      end.first
  end
end
