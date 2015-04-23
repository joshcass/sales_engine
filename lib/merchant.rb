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

  # def revenue
  #   look up all invoices for merchant
  #   check invoices against transactions and eliminate failed transactions
  #   look up all invoice items for each invoice
  #   multiply quantity by unit price to get total for each invoice item
  #   sum those up to get total revenue
  # end

  # def items_sold
  #   as revenue, but don't multiply quantity by unit price
  # end

  # def favorite_customer
  #   look up all invoices for merchant
  #   check invoices against transactions and eliminate failed transactions
  #   find the customer_id that appears on the most of these invoices
  #   look up that customer by their id
  #   return that customer to the caller
  # end

  # def customers_with_pending_invoices
  #   look up all invoices for merchant
  #   check invoices against transactions and eliminate successful transactions
  #   look up all the customers with remaining invoices by their ids
  #   return those customers to the caller
  # end
end
